'use strict'

import { registerUser } from '../services/auth/register.service.js'
import { loginUser } from '../services/auth/login.service.js'
import { logoutUser } from '../services/auth/logout.service.js'
import { refreshTokenUser } from '../services/auth/refreshToken.service.js'
import { forgotPasswordUser } from '../services/auth/forgotPassword.service.js'
import { resetPasswordUser } from '../services/auth/resetPassword.service.js'

export const register = async (req, res, next) => {
    try {
        const newUser = await registerUser(req.body)
        res.status(201).json({
            status: 'success',
            message: 'User registered successfully.',
            data: newUser,
        })
    } catch (error) {
        next(error)
    }
}

export const login = async (req, res, next) => {
    try {
        const { email, password } = req.body
        const ipAddress = req.ip
        const userAgent = req.headers['user-agent']

        const { accessToken, refreshToken } = await loginUser({
            email,
            password,
            ipAddress,
            userAgent,
        })

        res.cookie('refreshToken', refreshToken, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            maxAge: 7 * 24 * 60 * 60 * 1000,
        })

        res.status(200).json({
            status: 'success',
            message: 'User log in successfully.',
            data: { accessToken, refreshToken },
        })
    } catch (error) {
        next(error)
    }
}

export const forgotPassword = async (req, res, next) => {
    try {
        const { email } = req.body
        await forgotPasswordUser({ email })
        res.status(200).json({
            status: 'success',
            message: 'Reset password link sent to your email.',
        })
    } catch (error) {
        next(error)
    }
}

export const resetPassword = async (req, res, next) => {
    try {
        const { id, token, newPassword, confirmPassword } = req.body
        await resetPasswordUser({
            id,
            token,
            newPassword,
            confirmPassword,
        })
        res.status(200).json({
            status: 'success',
            message: 'Password updated successfully.',
        })
    } catch (error) {
        next(error)
    }
}

export const refreshToken = async (req, res, next) => {
    try {
        const incomingRefreshToken =
            req.body?.refreshToken || req.cookies?.refreshToken
        const { accessToken, refreshToken } = await refreshTokenUser(
            incomingRefreshToken
        )

        res.cookie('refreshToken', refreshToken, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            maxAge: 7 * 24 * 60 * 60 * 1000,
        })

        res.status(200).json({
            status: 'success',
            message: 'Token refreshed successfully.',
            data: { accessToken, refreshToken },
        })
    } catch (error) {
        next(error)
    }
}

export const logout = async (req, res, next) => {
    try {
        console.log('Cookies:', req.cookies)
        console.log('Body:', req.body)
        const incomingRefreshToken =
            req.cookies?.refreshToken || req.body?.refreshToken
        await logoutUser(incomingRefreshToken)

        res.clearCookie('refreshToken', {
            httpOnly: true,
            secure: true,
            sameSite: 'strict',
        })
        res.clearCookie('accessToken', {
            httpOnly: true,
            secure: true,
            sameSite: 'strict',
        })
        res.status(200).json({
            status: 'success',
            message: 'User logged out successfully.',
        })
    } catch (error) {
        next(error)
    }
}
