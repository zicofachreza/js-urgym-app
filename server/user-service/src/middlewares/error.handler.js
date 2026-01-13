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

        case 'SyntaxError':
            return res.status(400).json({
                status: 'error',
                message: 'Invalid JSON format in request body.',
            })

        case 'InvalidUser':
            return res.status(400).json({
                status: 'error',
                message: 'Email or Username are required.',
            })

        case 'InvalidEmail':
            return res
                .status(400)
                .json({ status: 'error', message: 'Email is required.' })

        case 'InvalidPassword':
            return res
                .status(400)
                .json({ status: 'error', message: 'Password is required.' })

        case 'InvalidNewPass':
            return res
                .status(400)
                .json({ status: 'error', message: 'New password is required.' })

        case 'InvalidConfirmPass':
            return res.status(400).json({
                status: 'error',
                message: 'Please confirm your password.',
            })

        case 'PasswordMismatch':
            return res.status(400).json({
                status: 'error',
                message: 'Password confirmation does not match.',
            })

        case 'InvalidOrExpiredToken':
            return res.status(400).json({
                status: 'error',
                message:
                    'The reset link is invalid or has expired. Please request a new password reset.',
            })

        case 'MissingRefreshToken':
            return res.status(400).json({
                status: 'error',
                message: 'Refresh token not provided.',
            })

        case 'InvalidCredentials':
            return res.status(401).json({
                status: 'error',
                message: 'Email/Username or Password is incorrect.',
            })

        case 'MissingToken':
            return res.status(401).json({
                status: 'error',
                message:
                    'Authentication token is missing. Please sign in again.',
            })

        case 'InvalidToken':
        case 'JsonWebTokenError':
        case 'InvalidAccessToken':
        case 'InvalidRefreshToken':
            return res.status(401).json({
                status: 'error',
                message: 'Invalid or expired token. Please sign in again.',
            })

        case 'TokenExpiredError':
        case 'AccessTokenExpired':
        case 'RefreshTokenExpired':
            return res.status(401).json({
                status: 'error',
                message: 'Your session has expired. Please sign in again.',
            })

        case 'RefreshTokenReuseDetected':
            return res.status(401).json({
                status: 'error',
                message: 'Suspicious activity detected. Please log in again.',
            })

        case 'NotFound':
            res.status(404).json({
                status: 'error',
                message: 'User not found.',
            })

        case 'EmailNotFound':
            return res.status(404).json({
                status: 'error',
                message: 'The email address you entered is not registered.',
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
