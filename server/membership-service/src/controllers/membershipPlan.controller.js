'use strict'

import { getMembershipPlanById } from '../services/getMembershipPlanById.service.js'

export const findMembershipPlanById = async (req, res, next) => {
    try {
        const { MembershipPlanId } = req.params

        const membershipPlan = await getMembershipPlanById(MembershipPlanId)

        res.status(200).json({
            status: 'success',
            message: 'Membership Plan data retrieved successfully.',
            data: membershipPlan,
        })
    } catch (err) {
        next(err)
    }
}
