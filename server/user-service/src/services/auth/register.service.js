'use strict'

import db from '../../models/index.js'
const { User } = db

export const registerUser = async ({ username, email, password }) => {
    const newUser = await User.create({ username, email, password })
    const user = await User.findByPk(newUser.id, {
        attributes: {
            exclude: ['password'],
        },
    })
    return user
}
