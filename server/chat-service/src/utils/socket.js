import { Server } from 'socket.io'
import { createAdapter } from '@socket.io/redis-adapter'
import { socketAuth } from '../middlewares/socketAuth.js'
import { redis } from '../redis/index.js'

export const initSocket = async (httpServer) => {
    const io = new Server(httpServer, {
        cors: { origin: '*' },
    })

    io.use(socketAuth)

    const pubClient = redis
    const subClient = redis.duplicate()

    io.adapter(createAdapter(pubClient, subClient))

    return io
}
