import { verifyToken } from '../utils/jwt.js'

export const socketAuth = (socket, next) => {
    try {
        const token =
            socket.handshake.auth?.token ||
            socket.handshake.headers?.authorization?.split(' ')[1]

        if (!token) {
            return next(new Error('Unauthorized: token missing'))
        }

        const decoded = verifyToken(token)

        // simpan ke socket context
        socket.user = {
            id: decoded.id,
            role: decoded.role, // 'user' | 'admin'
            email: decoded.email,
        }

        next()
    } catch (err) {
        console.error('❌ Socket auth failed:', err.message)
        next(new Error('Unauthorized: invalid token'))
    }
}
