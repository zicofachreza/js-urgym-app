'use strict'

import db from '../models/index.js'
const { Session, User } = db
import { Op } from 'sequelize'

export const cleanupExpiredSessions = async () => {
    const now = new Date()
    const deleted = await Session.destroy({
        where: {
            expiresAt: { [Op.lt]: now },
        },
    })

    console.log(`🧹 Cleaned up ${deleted} expired sessions`)
}

export const cleanupExpiredResetToken = async () => {
    const now = new Date()
    const deleted = await User.update(
        { resetToken: null, resetTokenExpires: null },
        {
            where: {
                resetTokenExpires: { [Op.lt]: now },
            },
        }
    )

    console.log(
        '🧹 Reset token expired cleaned up:',
        deleted[0],
        'rows updated'
    )
}
