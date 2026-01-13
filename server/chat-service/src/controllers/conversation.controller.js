'use strict'

import { createConversationWithAdmin } from '../services/createConversation.service.js'

export const startChatWithAdmin = async (req, res, next) => {
    try {
        const userId = req.user.id
        const adminId = req.body.adminId // atau ambil admin default

        const convo = await createConversationWithAdmin(userId, adminId)

        return res.status(201).json({
            message: 'Conversation created.',
            data: convo,
        })
    } catch (err) {
        next(err)
    }
}
