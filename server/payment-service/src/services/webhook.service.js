'use strict'

import crypto from 'crypto'
import db from '../models/index.js'
import { sendKafkaEvent } from '../kafka/producer.js'

const { Payment } = db

export const handlePaymentNotification = async (notification) => {
    const {
        order_id,
        transaction_id,
        transaction_status,
        signature_key,
        status_code,
        gross_amount,
    } = notification

    const payment = await Payment.findOne({
        where: { midtransOrderId: order_id },
    })
    if (!payment) return

    // ✅ verify signature
    const hash = crypto
        .createHash('sha512')
        .update(
            order_id +
                status_code +
                gross_amount +
                process.env.MIDTRANS_SERVER_KEY
        )
        .digest('hex')

    if (hash !== signature_key) {
        console.warn('Invalid signature key from Midtrans notification')
        return
    }

    // ✅ simpan transaction_id juga
    payment.midtransTransactionId = transaction_id

    // ✅ handle status payment
    if (
        transaction_status === 'settlement' ||
        transaction_status === 'capture'
    ) {
        payment.status = 'success'

        const startDate = new Date()
        const durationMonths = Number(payment.membershipType.split('_')[0])
        const endDate = new Date()
        endDate.setMonth(endDate.getMonth() + durationMonths)

        payment.startDate = startDate
        payment.endDate = endDate
        await payment.save()

        if (payment.status === 'success') {
            await sendKafkaEvent('MembershipActivated', {
                UserId: payment.UserId,
                membershipType: payment.membershipType,
                startDate,
                endDate,
            })
        }
    } else if (
        transaction_status === 'deny' ||
        transaction_status === 'cancel' ||
        transaction_status === 'expire'
    ) {
        payment.status = 'failed'
        await payment.save()
    } else if (transaction_status === 'pending') {
        payment.status = 'pending'
        await payment.save()
    }
}
