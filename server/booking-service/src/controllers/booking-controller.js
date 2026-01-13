'use strict'

import { createBookingGymClass } from '../services/createBooking.service.js'
import { cancelBookingGymClass } from '../services/cancelBooking.service.js'

export const createBooking = async (req, res, next) => {
    try {
        const { id } = req.user
        const { GymClassId } = req.body

        const booking = await createBookingGymClass({
            UserId: id,
            GymClassId,
        })

        res.status(201).json({
            message: 'Class booked successfully.',
            data: booking,
        })
    } catch (err) {
        next(err)
    }
}

export const cancelBooking = async (req, res, next) => {
    try {
        const { id } = req.user
        const { GymClassId } = req.body

        const booking = await cancelBookingGymClass({
            UserId: id,
            GymClassId,
        })

        res.status(200).json({
            message: 'Booking cancelled successfully.',
            data: booking,
        })
    } catch (err) {
        next(err)
    }
}
