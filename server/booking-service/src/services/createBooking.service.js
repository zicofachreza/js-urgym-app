'use strict'

import axios from 'axios'
import db from '../models/index.js'

const { Booking, OutboxEvent } = db

export const createBookingGymClass = async ({ UserId, GymClassId }) => {
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

    // Cek apakah user sudah booking kelas yang sama
    const existingBooking = await Booking.findOne({
        where: { UserId, GymClassId },
    })
    if (existingBooking) throw { name: 'AlreadyBooked' }

    // panggil gym-class-service via REST
    const gymClassUrl = `${process.env.GYM_CLASS_SERVICE_URL}/gym-classes/${GymClassId}`
    let gymClass
    try {
        const resp = await axios.get(gymClassUrl, { timeout: 5000 })
        gymClass = resp.data.data // sesuaikan shape response service kamu
    } catch (err) {
        if (err.response && err.response.status === 404)
            throw { name: 'GymClassNotFound' }
        throw { name: 'GymClassServiceUnavailable', detail: err.message }
    }

    // Validasi waktu kelas belum dimulai & kapasitas
    const now = new Date()
    const classStartTime = new Date(gymClass.schedule)
    if (now >= classStartTime) throw { name: 'ClassAlreadyStarted' }
    if (gymClass.capacity <= 0) throw { name: 'ClassFull' }

    const t = await db.sequelize.transaction()
    try {
        // Simpan booking ke DB
        const booking = await Booking.create(
            {
                UserId,
                GymClassId,
                bookingDate: now,
            },
            { transaction: t }
        )

        // publish Kafka event
        const event = {
            eventType: 'BOOKING_CREATED',
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
