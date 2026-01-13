'use strict'

import crypto from 'crypto'
import { Op } from 'sequelize'
import db from '../../models/index.js'
const { User, Session } = db
import { comparePassword } from '../../utils/bcrypt.js'
import { signRefreshToken, signToken } from '../../utils/jwt.js'
import { limitDeviceSessions } from '../../utils/helper.js'

export const loginUser = async ({ email, password, ipAddress, userAgent }) => {
    if (!email) throw { name: 'InvalidUser' }
    if (!password) throw { name: 'InvalidPassword' }

    const user = await User.findOne({
        where: { [Op.or]: [{ email }, { username: email }] },
    })
    if (!user) throw { name: 'InvalidCredentials' }

    const isPasswordValid = comparePassword(password, user.password)
    if (!isPasswordValid) throw { name: 'InvalidCredentials' }

    const accessToken = signToken({
        id: user.id,
        email: user.email,
        role: user.role,
    })
    const refreshToken = signRefreshToken({
        id: user.id,
        email: user.email,
        role: user.role,
    })

    const hashed = crypto
        .createHash('sha256')
        .update(refreshToken)
        .digest('hex')

    await limitDeviceSessions(user.id)

    await Session.create({
        UserId: user.id,
        hashedToken: hashed,
        deviceInfo: userAgent,
        ipAddress,
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 hari
        lastUsedAt: new Date(),
    })

    return { accessToken, refreshToken }
}
