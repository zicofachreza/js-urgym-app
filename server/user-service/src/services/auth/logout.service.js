'use strict'

import crypto from 'crypto'
import db from '../../models/index.js'
const { Session } = db

export const logoutUser = async (incomingRefreshToken) => {
    if (!incomingRefreshToken) throw { name: 'MissingRefreshToken' }

    const hashedIncoming = crypto
        .createHash('sha256')
        .update(incomingRefreshToken)
        .digest('hex')

    const existingToken = await Session.findOne({
        where: { hashedToken: hashedIncoming },
    })
    if (!existingToken) throw { name: 'InvalidRefreshToken' }

    await existingToken.destroy()
}
