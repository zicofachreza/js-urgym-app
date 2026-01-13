'use strict'

export default (err, req, res, next) => {
    if (process.env.NODE_ENV !== 'production') {
        console.error(err)
    }

    switch (err.name) {
        case 'SequelizeValidationError':
        case 'SequelizeUniqueConstraintError':
            return res.status(400).json({
                status: 'error',
                errorCode: 'VALIDATION_ERROR',
                message: err.errors[0].message,
            })

        case 'InvalidUserId':
            return res.status(400).json({
                status: 'error',
                message: 'UserId is required.',
            })

        case 'InvalidGymClassId':
            return res.status(400).json({
                status: 'error',
                message: 'GymClassId is required.',
            })

        case 'AlreadyBooked':
            return res.status(400).json({
                status: 'error',
                message: 'You have already booked this class.',
            })

        case 'UserNotFound':
            return res.status(404).json({
                status: 'error',
                message: 'The requested user was not found.',
            })

        case 'GymClassNotFound':
            return res.status(404).json({
                status: 'error',
                message: 'The requested gym class was not found.',
            })

        case 'ClassAlreadyStarted':
            return res.status(400).json({
                status: 'error',
                message: 'Cannot book a gym class that has already started.',
            })

        case 'CancelClassAlreadyStarted':
            return res.status(400).json({
                status: 'error',
                message: 'Cannot cancel a gym class that has already started.',
            })

        case 'ClassFull':
            return res.status(400).json({
                status: 'error',
                message: 'This gym class is already full.',
            })

        case 'MissingToken':
            return res.status(401).json({
                status: 'error',
                message:
                    'Authentication token is missing. Please sign in again.',
            })

        case 'InvalidToken':
        case 'JsonWebTokenError':
            return res.status(401).json({
                status: 'error',
                message: 'Invalid or expired token. Please sign in again.',
            })

        case 'MemberOnly':
            return res.status(403).json({
                status: 'error',
                message: 'Only members can book gym classes.',
            })

        case 'BookingNotFound':
            return res.status(404).json({
                status: 'error',
                message:
                    'No confirmed booking found for this user and gym class.',
            })

        case 'SequelizeDatabaseError':
            return res
                .status(500)
                .json({ status: 'error', message: 'Database query error.' })

        case 'UserServiceUnavailable':
            return res.status(503).json({
                status: 'error',
                message:
                    'User service is currently unavailable. Please try again later.',
            })

        case 'GymClassServiceUnavailable':
            return res.status(503).json({
                status: 'error',
                message:
                    'Gym Class service is currently unavailable. Please try again later.',
            })

        default:
            return res
                .status(500)
                .json({ status: 'error', message: 'Internal Server Error.' })
    }
}
