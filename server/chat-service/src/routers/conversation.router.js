'use strict'

import express from 'express'

import { authenticateUser } from '../middlewares/authenticateUser.js'
import { startChatWithAdmin } from '../controllers/conversation.controller.js'

const conversationRouter = express.Router()

conversationRouter.use(authenticateUser)
conversationRouter.post('/conversations/start', startChatWithAdmin)

export default conversationRouter
