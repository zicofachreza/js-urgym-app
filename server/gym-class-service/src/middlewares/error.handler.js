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

        case 'GymClassNotFound':
            return res.status(404).json({
                status: 'error',
                message: 'The requested gym class was not found.',
            })

        case 'GymClassNotYet':
            return res.status(404).json({
                status: 'error',
                message: 'No gym class yet.',
            })

        case 'SequelizeDatabaseError':
            return res
                .status(500)
                .json({ status: 'error', message: 'Database query error.' })

        default:
            return res
                .status(500)
                .json({ status: 'error', message: 'Internal Server Error.' })
    }
}
