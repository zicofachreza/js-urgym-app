'use strict'

import express from 'express'
import {
    register,
    login,
    logout,
    refreshToken,
    forgotPassword,
    resetPassword,
} from '../controllers/auth.controller.js'
import { authenticateUser } from '../middlewares/authenticate.user.js'

const authRouter = express.Router()

authRouter.post('/register', register)
authRouter.post('/login', login)
authRouter.post('/forgot-password', forgotPassword)
authRouter.post('/reset-password', resetPassword)

authRouter.use(authenticateUser)
authRouter.post('/refresh-token', refreshToken)
authRouter.post('/logout', logout)

export default authRouter
