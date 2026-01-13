'use strict'

import express from 'express'
import dotenv from 'dotenv'
import db from './models/index.js'
import membershipPlanRouter from './routers/membershipPlan.router.js'
import errorHandler from './middlewares/error.handler.js'

dotenv.config()

const app = express()
const port = process.env.PORT || 3005

app.use(express.json())
app.use(membershipPlanRouter)
app.use(errorHandler)

const startServer = async () => {
    try {
        await db.sequelize.sync({ alter: true })

        app.listen(port, () => {
            console.log(`🏋️ Membership Service running on port ${port}`)
        })
    } catch (err) {
        console.error('❌ Failed to initialize Kafka producer:', err)
        process.exit(1)
    }
}

startServer()
