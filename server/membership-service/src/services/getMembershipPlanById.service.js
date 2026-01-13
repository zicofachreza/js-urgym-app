'use strict'

import db from '../models/index.js'

const { MembershipPlan } = db

export const getMembershipPlanById = async (MembershipPlanId) => {
    const membershipPlan = await MembershipPlan.findByPk(MembershipPlanId)
    if (!membershipPlan) throw { name: 'MembershipPlanNotFound' }

    return membershipPlan
}
