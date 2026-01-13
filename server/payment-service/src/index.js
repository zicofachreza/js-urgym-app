'use strict'

import express from 'express'
import dotenv from 'dotenv'
import router from './routers/payment.router.js'
import errorHandler from './middlewares/error.handler.js'
import db from './models/index.js'

dotenv.config()

const app = express()
const port = process.env.PORT || 3004

app.use(express.json())

app.use(router)
app.use(errorHandler)

const startServer = async () => {
    try {
        await db.sequelize.sync({ alter: true })

        app.listen(port, () => {
            console.log(`🏋️ Payment service running on port ${port}`)
        })
    } catch (err) {
        console.error('❌ Failed to initialize Kafka producer:', err)
        process.exit(1)
    }
}

startServer()
