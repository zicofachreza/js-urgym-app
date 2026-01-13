// 'use strict'

// import { Kafka } from 'kafkajs'
// import db from '../models/index.js'

// const kafka = new Kafka({
//     clientId: 'user-service',
//     brokers: [process.env.KAFKA_BROKERS],
// })

// const consumer = kafka.consumer({
//     groupId: process.env.KAFKA_MEMBER_CONSUMER_GROUP || 'user-membership-group',
// })
// const { User } = db

// export const listenMembershipEvents = async () => {
//     await consumer.connect()
//     await consumer.subscribe({ topic: 'MembershipActivated' })

//     await consumer.run({
//         eachMessage: async ({ message }) => {
//             const event = JSON.parse(message.value.toString())
//             console.log('🎉 MembershipActivated received:', event)

//             const { UserId, endDate } = event

//             try {
//                 await User.update(
//                     {
//                         isMember: true,
//                         membershipExpiresAt: new Date(endDate),
//                     },
//                     { where: { id: UserId } }
//                 )
//             } catch (error) {
//                 console.error('Error updating user membership:', error)
//             }
//         },
//     })
// }
