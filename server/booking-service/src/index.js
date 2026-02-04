'use strict'

import dotenv from 'dotenv'
import cors from 'cors'
import express from 'express'
import bookingRouter from './routers/booking-router.js'
import errorHandler from './middlewares/error.handler.js'
import { initProducer } from './kafka/producer.js'
import { startOutboxWorker } from './jobs/outbox-worker.js'

dotenv.config()

const app = express()
const port = process.env.PORT || 3002

app.use(cors())
app.use(express.json())
app.use(bookingRouter)
app.use(errorHandler)

const startServer = async () => {
    try {
        await initProducer()
        await startOutboxWorker()

        app.listen(port, () => {
            console.log(`🏋️ Booking Service running on port ${port}`)
        })
    } catch (err) {
        console.error('❌ Failed to initialize service:', err)
        process.exit(1)
    }
}

startServer()
