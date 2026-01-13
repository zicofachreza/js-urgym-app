'use strict'

import { Kafka } from 'kafkajs'
import db from '../models/index.js'
import dotenv from 'dotenv'
dotenv.config()

const { GymClass, FailedEvent } = db

const kafka = new Kafka({
    clientId: 'gym-class-service',
    brokers: (process.env.KAFKA_BROKERS || 'localhost:9092').split(','),
})

const consumer = kafka.consumer({
    groupId: process.env.KAFKA_CONSUMER_GROUP || 'gym-class-service-group',
})

const MAX_RETRIES = 3
const RETRY_DELAY_MS = 3000 // 3 seconds

export const initConsumer = async () => {
    await consumer.connect()
    console.log('✅ Kafka consumer connected to booking-events topic')

    await consumer.subscribe({
        topic: process.env.KAFKA_TOPIC_BOOKINGS || 'booking-events',
        fromBeginning: false,
    })

    await consumer.run({
        eachMessage: async ({ topic, partition, message }) => {
            const value = message.value.toString()
            const event = JSON.parse(value)
            const { eventType, data } = event

            console.log(
                `📩 Received event: ${eventType} (BookingId: ${data.BookingId})`
            )

            try {
                await processEventWithRetry(event)
            } catch (err) {
                console.error(
                    `❌ Final failure processing event: ${err.message}`
                )
                await saveToFailedEvents(event, err)
            }
        },
    })
}

async function processEventWithRetry(event) {
    let attempt = 0
    let lastError

    while (attempt < MAX_RETRIES) {
        try {
            await processEvent(event)
            console.log(`✅ Event ${event.eventType} processed successfully`)
            return
        } catch (err) {
            attempt++
            lastError = err
            console.warn(`⚠️ Attempt ${attempt} failed: ${err.message}`)

            if (attempt < MAX_RETRIES) {
                await delay(RETRY_DELAY_MS)
            }
        }
    }

    // semua percobaan gagal → masukkan ke dead-letter
    throw lastError
}

async function processEvent(event) {
    const { eventType, data } = event

    switch (eventType) {
        case 'BOOKING_CREATED':
            await handleBookingCreated(data)
            break
        case 'BOOKING_CANCELLED':
            await handleBookingCancelled(data)
            break
        default:
            console.warn('⚠️ Unknown event type:', eventType)
    }
}

async function handleBookingCreated({ GymClassId }) {
    const gymClass = await GymClass.findByPk(GymClassId)
    if (!gymClass) throw new Error(`GymClass ${GymClassId} not found`)

    if (gymClass.capacity > 0) {
        gymClass.capacity -= 1
        await gymClass.save()
        console.log(
            `📉 Capacity decreased for class ${GymClassId}: ${gymClass.capacity}`
        )
    } else {
        console.warn(`⚠️ Class ${GymClassId} already full`)
    }
}

async function handleBookingCancelled({ GymClassId }) {
    const gymClass = await GymClass.findByPk(GymClassId)
    if (!gymClass) throw new Error(`GymClass ${GymClassId} not found`)

    gymClass.capacity += 1
    await gymClass.save()
    console.log(
        `📈 Capacity increased for class ${GymClassId}: ${gymClass.capacity}`
    )
}

// === Helpers ===

async function saveToFailedEvents(event, err) {
    await FailedEvent.create({
        eventType: event.eventType,
        payload: event.data,
        errorMessage: err.message,
        retryCount: MAX_RETRIES,
        status: 'FAILED',
    })
    console.log('💾 Event saved to FailedEvents for manual review')
}

function delay(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms))
}
