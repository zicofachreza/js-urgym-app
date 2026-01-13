'use strict'

import cron from 'node-cron'
import {
    cleanupExpiredResetToken,
    cleanupExpiredSessions,
} from '../utils/cleaner.js'

cron.schedule(
    '1 0 * * *',
    async () => {
        console.log('🕛 Running daily user check...')
        await cleanupExpiredSessions()
        await cleanupExpiredResetToken()
    },
    {
        timezone: 'Asia/Jakarta',
    }
)
