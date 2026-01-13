'use strict'

import { Kafka } from 'kafkajs'
import dotenv from 'dotenv'
dotenv.config()

const kafka = new Kafka({
    clientId: 'booking-service',
    brokers: (process.env.KAFKA_BROKERS || 'localhost:9092').split(','),
})

export const producer = kafka.producer()

export const initProducer = async () => {
    await producer.connect()
    console.log('✅ Kafka producer connected')
}

// simple wrapper
export const kafkaProducer = {
    send: async (opts) => {
        return producer.send(opts)
    },
}
