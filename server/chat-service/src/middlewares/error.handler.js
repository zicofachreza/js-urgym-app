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
