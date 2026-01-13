'use strict'

import express from 'express'
import { findUserById } from '../controllers/user.controller.js'

const userRouter = express.Router()

userRouter.get('/users/:UserId', findUserById)

export default userRouter
