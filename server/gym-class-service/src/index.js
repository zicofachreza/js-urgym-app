'use strict'

import dotenv from 'dotenv'
import cors from 'cors'
import express from 'express'
import gymClassRouter from './routers/gymClass-router.js'
import { initConsumer } from './kafka/consumer.js'
import errorHandler from './middlewares/error.handler.js'

dotenv.config()

const app = express()
const port = process.env.PORT || 3003

app.use(cors())
app.use(express.json())
app.use(gymClassRouter)
app.use(errorHandler)

const startServer = async () => {
    try {
        await initConsumer()

        app.listen(port, () => {
            console.log(`🏋️ Gym Class Service running on port ${port}`)
        })
    } catch (err) {
        console.error('❌ Failed to initialize service:', err)
        process.exit(1)
    }
}

startServer()
