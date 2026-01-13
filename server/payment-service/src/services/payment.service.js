'use strict'

import axios from 'axios'
import db from '../models/index.js'
import { snap } from '../utils/midtrans.js'

const { Payment } = db

export const createMembershipPayment = async ({ UserId, MembershipPlanId }) => {
    if (!UserId) throw { name: 'InvalidUserId' }
    if (!MembershipPlanId) throw { name: 'InvalidMembershipPlanId' }

    const pendingPayment = await Payment.findOne({
        where: {
            UserId,
            status: 'pending',
        },
        order: [['createdAt', 'DESC']],
    })

    if (pendingPayment) throw { name: 'PendingPaymentExists' }

    const activeMembership = await Payment.findOne({
        where: {
            UserId,
            status: 'success',
        },
        order: [['endDate', 'DESC']],
    })

    if (activeMembership && activeMembership.endDate > new Date())
        throw { name: 'ActiveMembershipExists' }

    const membershipUrl = `${process.env.MEMBERSHIP_SERVICE_URL}/membership-plans/${MembershipPlanId}`
    let membership
    try {
        const resp = await axios.get(membershipUrl, { timeout: 5000 })
        membership = resp.data.data
    } catch (error) {
        if (error.response && error.response.status === 404)
            throw { name: 'MembershipPlanNotFound' }
        throw { name: 'MembershipServiceUnavailable', detail: error.message }
    }

    const { price, type } = membership

    const orderId = `MEMBER-${Date.now()}-${Math.floor(Math.random() * 1000)}`

    const payment = await Payment.create({
        UserId,
        membershipType: type,
        amount: price,
        midtransOrderId: orderId,
    })

    const transaction = await snap.createTransaction({
        transaction_details: {
            order_id: orderId,
            gross_amount: price,
        },
        customer_details: {
            first_name: `User-${UserId}`,
        },
    })

    payment.snapToken = transaction.token
    payment.redirectUrl = transaction.redirect_url
    await payment.save()

    return {
        payment,
        redirectUrl: transaction.redirect_url,
        snapToken: transaction.token,
    }
}
