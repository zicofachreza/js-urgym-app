'use strict'

import express from 'express'
import { findMembershipPlanById } from '../controllers/membershipPlan.controller.js'

const membershipPlanRouter = express.Router()

membershipPlanRouter.get(
    '/membership-plans/:MembershipPlanId',
    findMembershipPlanById
)

export default membershipPlanRouter
