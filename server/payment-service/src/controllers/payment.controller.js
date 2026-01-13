'use strict'

import { createMembershipPayment } from '../services/payment.service.js'
import { handlePaymentNotification } from '../services/webhook.service.js'

export const createPayment = async (req, res, next) => {
    try {
        const { id } = req.user
        const { MembershipPlanId } = req.body

        const result = await createMembershipPayment({
            UserId: id,
            MembershipPlanId,
        })
        res.status(201).json({
            status: 'success',
            message: 'Membership paid successfully.',
            data: result,
        })
    } catch (error) {
        next(error)
    }
}

export const midtransNotification = async (req, res, next) => {
    try {
        const payload = req.body
        await handlePaymentNotification(payload)
        res.status(200).json({
            status: 'ok',
            message: 'Notification received.',
        })
    } catch (error) {
        res.status(200).json({ status: 'ignored' })
        next(error)
    }
}
