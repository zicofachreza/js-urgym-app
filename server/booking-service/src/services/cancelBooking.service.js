'use strict'

import axios from 'axios'
import db from '../models/index.js'

const { Booking, OutboxEvent } = db

export const cancelBookingGymClass = async ({ UserId, GymClassId }) => {
    if (!UserId) throw { name: 'InvalidUserId' }
    if (!GymClassId) throw { name: 'InvalidGymClassId' }

    const userUrl = `${process.env.USER_SERVICE_URL}/users/${UserId}`
    let user
    try {
        const resp = await axios.get(userUrl, { timeout: 5000 })
        user = resp.data.data // sesuaikan shape response service kamu
    } catch (err) {
        if (err.response && err.response.status === 404)
            throw { name: 'UserNotFound' }
        throw { name: 'UserServiceUnavailable', detail: err.message }
    }

    if (!user.isMember) throw { name: 'MemberOnly' }

    // Cari booking aktif
    const booking = await Booking.findOne({
        where: { UserId, GymClassId, status: 'confirmed' },
    })
    if (!booking) throw { name: 'BookingNotFound' }

    // panggil gym-class-service via REST
    const gymClassUrl = `${process.env.GYM_CLASS_SERVICE_URL}/gym-classes/${GymClassId}`
    let gymClass
    try {
        const resp = await axios.get(gymClassUrl, { timeout: 5000 })
        gymClass = resp.data.data
    } catch (err) {
        if (err.response && err.response.status === 404)
            throw { name: 'GymClassNotFound' }
        throw { name: 'GymClassServiceUnavailable', detail: err.message }
    }

    // Validasi waktu: tidak bisa cancel kalau kelas sudah mulai
    const now = new Date()
    if (new Date(gymClass.schedule) <= now) {
        throw { name: 'CancelClassAlreadyStarted' }
    }

    // Jalankan dalam transaksi
    const t = await db.sequelize.transaction()
    try {
        // Ubah status booking jadi CANCELLED
        booking.status = 'cancelled'
        booking.cancelledAt = now
        await booking.save({ transaction: t })

        // Simpan event ke tabel OutboxEvent (bukan langsung kirim Kafka)
        const event = {
            eventType: 'BOOKING_CANCELLED',
            data: {
                BookingId: booking.id,
                UserId,
                GymClassId,
                timestamp: new Date().toISOString(),
            },
        }

        await OutboxEvent.create(
            { eventType: event.eventType, payload: event.data },
            { transaction: t }
        )

        await t.commit()
        return booking
    } catch (error) {
        await t.rollback()
        throw error
    }
}
