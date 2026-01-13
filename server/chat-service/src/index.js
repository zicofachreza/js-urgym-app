'use strict'

import express from 'express'
import dotenv from 'dotenv'
import http from 'http'
import db from './models/index.js'
import { initSocket } from './utils/socket.js'
import { registerChatSocket } from './sockets/chat.socket.js'
import conversationRouter from './routers/conversation.router.js'
import errorHandler from './middlewares/error.handler.js'

dotenv.config()

const app = express()
const port = process.env.PORT || 3006
const server = http.createServer(app)

app.use(express.json())
app.use(conversationRouter)
app.use(errorHandler)

const startServer = async () => {
    try {
        if (process.env.NODE_ENV === 'development') {
            await db.sequelize.sync({ alter: true }) // test -> force: true
        }

        const io = await initSocket(server)
        registerChatSocket(io)

        server.listen(port, () => {
            console.log(`🏋️ Chat service running on port ${port}`)
        })
    } catch (err) {
        console.error('❌ Failed to initialize server:', err)
        process.exit(1)
    }
}

startServer()
