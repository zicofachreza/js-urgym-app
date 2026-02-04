'use strict'

import db from '../models/index.js'
import { setOnline } from '../redis/presence.js'

const { Conversation, Message, Participant, MessageRead } = db

export const registerChatSocket = (io) => {
    io.on('connection', (socket) => {
        console.log(`🔌 Socket connected: ${socket.id} user=${socket.user.id}`)

        const currentUser = socket.user

        /* =========================
         * PRESENCE
         * ========================= */
        setInterval(() => {
            setOnline(currentUser.id)
        }, 30_000)

        /* =========================
         * JOIN CONVERSATION
         * ========================= */
        socket.on('join:conversation', async ({ conversationId }) => {
            try {
                const participant = await Participant.findOne({
                    where: {
                        ConversationId: conversationId,
                        UserId: currentUser.id,
                    },
                })

                if (!participant) {
                    socket.emit('chat:error', {
                        message: 'Not participant of conversation',
                    })
                    return
                }

                socket.join(`conversation:${conversationId}`)
                console.log(
                    `👥 User ${currentUser.id} joined conversation ${conversationId}`
                )
            } catch (err) {
                console.error('❌ Join conversation failed:', err)
                socket.emit('chat:error', {
                    message: 'Failed to join conversation',
                })
            }
        })

        /* =========================
         * SEND MESSAGE
         * ========================= */
        socket.on('send:message', async ({ conversationId, content }) => {
            try {
                if (!conversationId || !content) {
                    socket.emit('chat:error', {
                        message: 'Invalid message payload',
                    })
                    return
                }

                const convo = await Conversation.findByPk(conversationId)
                if (!convo || convo.status === 'closed') {
                    socket.emit('chat:error', {
                        message: 'Conversation already closed',
                    })
                    return
                }

                // pastikan sender participant
                const participant = await Participant.findOne({
                    where: {
                        ConversationId: conversationId,
                        UserId: currentUser.id,
                    },
                })

                if (!participant) {
                    socket.emit('chat:error', {
                        message: 'Not allowed to send message',
                    })
                    return
                }

                const message = await Message.create({
                    ConversationId: conversationId,
                    senderId: currentUser.id,
                    senderRole: currentUser.role,
                    content,
                    messageType: 'text',
                })

                await Conversation.update(
                    { lastMessageAt: new Date() },
                    { where: { id: conversationId } }
                )

                io.to(`conversation:${conversationId}`).emit('new:message', {
                    id: message.id,
                    conversationId,
                    senderId: currentUser.id,
                    senderRole: currentUser.role,
                    content,
                    createdAt: message.createdAt,
                })
            } catch (err) {
                console.error('❌ Send message failed:', err)
                socket.emit('chat:error', { message: 'Failed sending message' })
            }
        })

        /* =========================
         * READ RECEIPT
         * ========================= */
        socket.on('message:read', async ({ messageId }) => {
            try {
                if (!messageId) return

                const msg = await Message.findByPk(messageId)
                if (!msg) return

                const participant = await Participant.findOne({
                    where: {
                        ConversationId: msg.ConversationId,
                        UserId: currentUser.id,
                    },
                })

                if (!participant) return

                await MessageRead.findOrCreate({
                    where: {
                        MessageId: messageId,
                        readerId: currentUser.id,
                    },
                    defaults: {
                        readAt: new Date(),
                    },
                })

                io.to(`conversation:${msg.ConversationId}`).emit(
                    'message:read',
                    {
                        messageId,
                        readerId: currentUser.id,
                    }
                )
            } catch (err) {
                console.error('❌ Read receipt failed:', err)
            }
        })

        /* =========================
         * DISCONNECT
         * ========================= */
        socket.on('disconnect', () => {
            console.log(
                `❌ Socket disconnected: ${socket.id} user=${currentUser.id}`
            )
        })
    })
}
