'use strict'

import jwt from 'jsonwebtoken'
const accessSecret = process.env.JWT_ACCESS_SECRET
const refreshSecret = process.env.JWT_REFRESH_SECRET

export const signToken = (payload) =>
    jwt.sign(payload, accessSecret, { expiresIn: '1d' })

export const signRefreshToken = (payload) =>
    jwt.sign(payload, refreshSecret, { expiresIn: '7d' })

export const verifyToken = (token) => {
    try {
        return jwt.verify(token, accessSecret)
    } catch (err) {
        if (err.name === 'TokenExpiredError')
            throw { name: 'AccessTokenExpired', original: err }
        throw { name: 'InvalidAccessToken', original: err }
    }
}

export const verifyRefreshToken = (token) => {
    try {
        return jwt.verify(token, refreshSecret)
    } catch (err) {
        if (err.name === 'TokenExpiredError')
            throw { name: 'RefreshTokenExpired', original: err }
        throw { name: 'InvalidRefreshToken', original: err }
    }
}
