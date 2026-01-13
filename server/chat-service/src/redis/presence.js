import { redis } from './index.js'

export const setOnline = (userId) =>
    redis.set(`online:${userId}`, '1', 'EX', 60)

export const isOnline = async (userId) =>
    (await redis.get(`online:${userId}`)) === '1'
