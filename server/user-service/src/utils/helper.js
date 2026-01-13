'use strict'

import db from '../models/index.js'
const { Session } = db

export const limitDeviceSessions = async (userId, maxDevices = 5) => {
    const tokens = await Session.findAll({
        where: { UserId: userId },
        order: [['updatedAt', 'ASC']],
    })

    if (tokens.length >= maxDevices) {
        const tokensToDelete = tokens.slice(0, tokens.length - maxDevices + 1)
        for (const oldToken of tokensToDelete) {
            await oldToken.destroy()
        }
    }
}
