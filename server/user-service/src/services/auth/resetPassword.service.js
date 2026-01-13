'use strict'

import crypto from 'crypto'
import db from '../../models/index.js'
const { User } = db

export const resetPasswordUser = async ({
    id,
    token,
    newPassword,
    confirmPassword,
}) => {
    if (!newPassword) throw { name: 'InvalidNewPass' }
    if (!confirmPassword) throw { name: 'InvalidConfirmPass' }
    if (newPassword !== confirmPassword) throw { name: 'PasswordMismatch' }

    const user = await User.findByPk(id)
    if (!user) throw { name: 'NotFound' }

    if (!user.resetToken || !user.resetTokenExpires)
        throw { name: 'InvalidOrExpiredToken' }

    const hashedToken = crypto.createHash('sha256').update(token).digest('hex')
    const isTokenValid = hashedToken === user.resetToken
    const isExpired = new Date() > user.resetTokenExpires
    if (!isTokenValid || isExpired) throw { name: 'InvalidOrExpiredToken' }

    user.password = newPassword
    user.resetToken = null
    user.resetTokenExpires = null
    await user.save()
}
