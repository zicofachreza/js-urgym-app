'use strict'

import db from '../models/index.js'
const { User } = db
import { verifyToken } from '../utils/jwt.js'

export const authenticateUser = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization
        if (!authHeader) throw { name: 'MissingToken' }

        const [scheme, accessToken] = authHeader.split(' ')
        if (scheme !== 'Bearer' || !accessToken) throw { name: 'InvalidToken' }

        const payload = verifyToken(accessToken)
        const user = await User.findByPk(payload.id)
        if (!user) throw { name: 'InvalidToken' }

        req.user = user
        next()
    } catch (error) {
        next(error)
    }
}
