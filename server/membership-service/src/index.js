'use strict'

import dotenv from 'dotenv'
import cors from 'cors'
import express from 'express'
import membershipPlanRouter from './routers/membershipPlan.router.js'
import errorHandler from './middlewares/error.handler.js'

dotenv.config()

const app = express()
const port = process.env.PORT || 3005

app.use(cors())
app.use(express.json())
app.use(membershipPlanRouter)
app.use(errorHandler)

const startServer = async () => {
    try {
        app.listen(port, () => {
            console.log(`🏋️ Membership Service running on port ${port}`)
        })
    } catch (err) {
        console.error('❌ Failed to initialize service:', err)
        process.exit(1)
    }
}

startServer()
