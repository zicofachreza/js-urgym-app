'use strict'

import express from 'express'
import {
    createPayment,
    midtransNotification,
} from '../controllers/payment.controller.js'
import { authenticateUser } from '../middlewares/authenticateUser.js'

const paymentRouter = express.Router()

paymentRouter.post('/payments/notification', midtransNotification)
paymentRouter.use(authenticateUser)
paymentRouter.post('/payments/membership', createPayment)

export default paymentRouter
