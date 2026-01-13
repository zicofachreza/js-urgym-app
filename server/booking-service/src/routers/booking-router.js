'use strict'

import express from 'express'
import {
    createBooking,
    cancelBooking,
} from '../controllers/booking-controller.js'
import { authenticateUser } from '../middlewares/authenticateUser.js'

const bookingRouter = express.Router()

bookingRouter.use(authenticateUser)
bookingRouter.post('/bookings', createBooking)
bookingRouter.post('/bookings/cancel', cancelBooking)

export default bookingRouter
