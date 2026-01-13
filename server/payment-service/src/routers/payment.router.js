'use strict'

import express from 'express'
import {
    createPayment,
    midtransNotification,
} from '../controllers/payment.controller.js'
import { authenticateUser } from '../middlewares/authenticateUser.js'

const router = express.Router()

router.post('/payments/notification', midtransNotification)
router.use(authenticateUser)
router.post('/payments/membership', createPayment)

export default router
