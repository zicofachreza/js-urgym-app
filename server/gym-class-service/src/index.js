'use strict'

import express from 'express'
import dotenv from 'dotenv'
import db from './models/index.js'
import gymClassRouter from './routers/gymClass-router.js'
import { initConsumer } from './kafka/consumer.js'
import errorHandler from '../middlewares/error.handler.js'

dotenv.config()

const app = express()
const port = process.env.PORT || 3003

app.use(express.json())
app.use(gymClassRouter)
app.use(errorHandler)

const startServer = async () => {
    try {
        await db.sequelize.sync({ alter: true })
        await initConsumer()

        app.listen(port, () => {
            console.log(`🏋️ Gym Class Service running on port ${port}`)
        })
    } catch (err) {
        console.error('❌ Failed to initialize Kafka producer:', err)
        process.exit(1)
    }
}

startServer()
