'use strict'

import express from 'express'
import { findGymClassById } from '../controllers/gymClass-controller.js'

const gymClassRouter = express.Router()

gymClassRouter.get('/gym-classes/:GymClassId', findGymClassById)

export default gymClassRouter
