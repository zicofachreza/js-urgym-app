'use strict'
import { Kafka } from 'kafkajs'

const kafka = new Kafka({
    clientId: 'payment-service',
    brokers: [process.env.KAFKA_BROKERS],
})

const producer = kafka.producer()
let connected = false

export const sendKafkaEvent = async (topic, message) => {
    if (!connected) {
        await producer.connect()
        connected = true
    }
    await producer.send({
        topic,
        messages: [{ value: JSON.stringify(message) }],
    })
}
