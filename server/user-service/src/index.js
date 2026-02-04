'use strict'

import dotenv from 'dotenv'
import cors from 'cors'
import express from 'express'
import cookieParser from 'cookie-parser'
import authRouter from './routers/auth.router.js'
import userRouter from './routers/user.router.js'
import errorHandler from './middlewares/error.handler.js'
import { listenMembershipEvents } from './kafka/membership.consumer.js'

dotenv.config()

const app = express()
const port = process.env.PORT || 3001

app.use(cors())
app.use(express.json())
app.use(cookieParser())
app.use(userRouter)
app.use(authRouter)
app.use(errorHandler)

import './cron/user.cron.js'

const startServer = async () => {
    try {
        await listenMembershipEvents()

        app.listen(port, () => {
            console.log(`🏋️ User service running on port ${port}`)
        })
    } catch (err) {
        console.error('❌ Failed to initialize service:', err)
        process.exit(1)
    }
}

startServer()
