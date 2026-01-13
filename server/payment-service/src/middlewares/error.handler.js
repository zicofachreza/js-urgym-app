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

        case 'InvalidMembershipPlanId':
            return res.status(400).json({
                status: 'error',
                message: 'MembershipPlanId is required.',
            })

        case 'PendingPaymentExists':
            return res.status(400).json({
                status: 'error',
                message:
                    'You still have a pending payment. Please complete or cancel it before creating a new one.',
            })

        case 'ActiveMembershipExists':
            return res.status(400).json({
                status: 'error',
                message: 'You still have an active membership.',
            })

        case 'MissingToken':
            return res.status(401).json({
                status: 'error',
                message:
                    'Authentication token is missing. Please sign in again.',
            })

        case 'InvalidToken':
        case 'JsonWebTokenError':
        case 'TokenExpiredError':
            return res.status(401).json({
                status: 'error',
                message: 'Invalid or expired token. Please sign in again.',
            })

        case 'MembershipPlanNotFound':
            return res.status(404).json({
                status: 'error',
                message: 'The requested membership plan was not found.',
            })

        case 'SequelizeDatabaseError':
            return res
                .status(500)
                .json({ status: 'error', message: 'Database query error.' })

        case 'MembershipServiceUnavailable':
            return res.status(503).json({
                status: 'error',
                message:
                    'Membership service is currently unavailable. Please try again later.',
            })

        default:
            return res
                .status(500)
                .json({ status: 'error', message: 'Internal Server Error.' })
    }
}
