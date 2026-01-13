'use strict'

import { getUserById } from '../services/user/getUserById.service.js'

export const findUserById = async (req, res, next) => {
    try {
        const { UserId } = req.params

        const user = await getUserById(UserId)

        res.status(200).json({
            status: 'success',
            message: 'User data retrieved successfully.',
            data: user,
        })
    } catch (error) {
        next(error)
    }
}
