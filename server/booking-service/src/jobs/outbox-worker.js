'use strict'

import { kafkaProducer } from '../kafka/producer.js'
import db from '../models/index.js'
const { OutboxEvent } = db

export const startOutboxWorker = async () => {
    console.log('🌀 Outbox worker started...')
    setInterval(async () => {
        const pendingEvents = await OutboxEvent.findAll({
            where: { status: 'PENDING' },
            limit: 10,
            logging: false,
        })

        for (const event of pendingEvents) {
            try {
                await kafkaProducer.send({
                    topic: process.env.KAFKA_TOPIC_BOOKINGS || 'booking-events',
                    messages: [
                        {
                            key: String(event.id),
                            value: JSON.stringify({
                                eventType: event.eventType,
                                data: event.payload,
                            }),
                        },
                    ],
                })

                event.status = 'SENT'
                await event.save()
                console.log(`✅ Event ${event.id} sent successfully`)
            } catch (err) {
                event.status = 'FAILED'
                event.errorMessage = err.message
                await event.save()
                console.error(
                    `❌ Failed sending event ${event.id}: ${err.message}`
                )
            }
        }
    }, 5000) // run every 5 seconds
}
