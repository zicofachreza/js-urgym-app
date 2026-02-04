'use strict'

import express from 'express'
import {
    findAllGymClasses,
    findGymClassById,
} from '../controllers/gymClass-controller.js'

const gymClassRouter = express.Router()

gymClassRouter.get('/gym-classes', findAllGymClasses)
gymClassRouter.get('/gym-classes/:GymClassId', findGymClassById)

export default gymClassRouter
