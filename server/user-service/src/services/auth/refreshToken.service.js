'use strict'

import crypto from 'crypto'
import db from '../../models/index.js'
const { User, Session } = db
import {
    signRefreshToken,
    signToken,
    verifyRefreshToken,
} from '../../utils/jwt.js'

export const refreshTokenUser = async (incomingRefreshToken) => {
    if (!incomingRefreshToken) throw { name: 'MissingRefreshToken' }

    let payload
    try {
        payload = verifyRefreshToken(incomingRefreshToken)
    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            throw { name: 'RefreshTokenExpired' }
        }
        if (error.name === 'JsonWebTokenError') {
            throw { name: 'InvalidRefreshToken' }
        }
        throw error
    }

    const user = await User.findByPk(payload.id)
    if (!user) throw { name: 'InvalidRefreshToken' }

    const hashedIncoming = crypto
        .createHash('sha256')
        .update(incomingRefreshToken)
        .digest('hex')

    const existingToken = await Session.findOne({
        where: { UserId: user.id, hashedToken: hashedIncoming },
    })

    if (!existingToken) {
        console.warn(`⚠️ Token reuse detected for userId ${user.id}`)
        await Session.destroy({ where: { UserId: user.id } })
        throw { name: 'RefreshTokenReuseDetected' }
    }

    if (new Date() > existingToken.expiresAt) {
        await existingToken.destroy()
        throw { name: 'RefreshTokenExpired' }
    }

    const newAccessToken = signToken({ id: user.id, email: user.email })
    const newRefreshToken = signRefreshToken({
        id: user.id,
        email: user.email,
    })
    const hashedNew = crypto
        .createHash('sha256')
        .update(newRefreshToken)
        .digest('hex')

    existingToken.hashedToken = hashedNew
    existingToken.expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
    existingToken.lastUsedAt = new Date()
    await existingToken.save()

    return {
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
    }
}
