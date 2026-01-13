'use strict'

import db from '../../models/index.js'

const { User } = db

export const getUserById = async (UserId) => {
    const user = await User.findByPk(UserId)
    if (!user) throw { name: 'NotFound' }

    return user
}
