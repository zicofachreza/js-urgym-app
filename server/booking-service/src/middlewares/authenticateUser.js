'use strict'

import { verifyToken } from '../utils/jwt.js'

export const authenticateUser = (req, res, next) => {
    try {
        const authHeader = req.headers.authorization
        if (!authHeader) throw { name: 'MissingToken' }

        const [scheme, accessToken] = authHeader.split(' ')
        if (scheme !== 'Bearer' || !accessToken) throw { name: 'InvalidToken' }

        // ✅ Verifikasi JWT (tidak perlu akses DB user-service)
        const payload = verifyToken(accessToken)
        req.user = { id: payload.id, email: payload.email } // cukup ID & email

        next()
    } catch (error) {
        next(error)
    }
}
