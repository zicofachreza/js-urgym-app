'use strict'

import jwt from 'jsonwebtoken'

const access_secret = process.env.JWT_ACCESS_SECRET

export const verifyToken = (token) => {
    return jwt.verify(token, access_secret)
}
