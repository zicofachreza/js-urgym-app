'use strict'

import dotenv from 'dotenv'
import cors from 'cors'
import express from 'express'
import http from 'http'
import { initSocket } from './utils/socket.js'
import { registerChatSocket } from './sockets/chat.socket.js'
import conversationRouter from './routers/conversation.router.js'
import errorHandler from './middlewares/error.handler.js'

dotenv.config()

const app = express()
const port = process.env.PORT || 3006
const server = http.createServer(app)

app.use(cors())
app.use(express.json())
app.use(conversationRouter)
app.use(errorHandler)

const startServer = async () => {
    try {
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
