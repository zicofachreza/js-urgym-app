'use strict'

import dotenv from 'dotenv'
import cors from 'cors'
import express from 'express'
import paymentRouter from './routers/payment.router.js'
import errorHandler from './middlewares/error.handler.js'

dotenv.config()

const app = express()
const port = process.env.PORT || 3004

app.use(cors())
app.use(express.json())
app.use(paymentRouter)
app.use(errorHandler)

const startServer = async () => {
    try {
        app.listen(port, () => {
            console.log(`🏋️ Payment service running on port ${port}`)
        })
    } catch (err) {
        console.error('❌ Failed to initialize service:', err)
        process.exit(1)
    }
}

startServer()
