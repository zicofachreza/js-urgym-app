'use strict'

import { getAllGymClasses } from '../services/getAllGymClasses.service.js'
import { getGymClassById } from '../services/getGymClassById.service.js'

export const findGymClassById = async (req, res, next) => {
    try {
        const { GymClassId } = req.params

        const gymClass = await getGymClassById(GymClassId)

        res.status(200).json({
            status: 'success',
            message: 'Gym Class data retrieved successfully.',
            data: gymClass,
        })
    } catch (err) {
        next(err)
    }
}

export const findAllGymClasses = async (req, res, next) => {
    try {
        const gymClasses = await getAllGymClasses()

        res.status(200).json({
            status: 'success',
            message: 'All Gym Classes retrieved successfully.',
            data: gymClasses,
        })
    } catch (err) {
        next(err)
    }
}
