'use strict'

import crypto from 'crypto'
import db from '../../models/index.js'
const { User } = db
import { sendMail } from '../../utils/mailer.js'

export const forgotPasswordUser = async ({ email }) => {
    if (!email) throw { name: 'InvalidEmail' }

    const user = await User.findOne({
        where: { email },
    })
    if (!user) throw { name: 'EmailNotFound' }

    const resetToken = crypto.randomBytes(32).toString('hex')
    const hashedToken = crypto
        .createHash('sha256')
        .update(resetToken)
        .digest('hex')

    user.resetToken = hashedToken
    user.resetTokenExpires = new Date(Date.now() + 15 * 60 * 1000) // 15 menit
    await user.save()

    const resetLink = `${process.env.FRONTEND_URL}/reset-password?token=${resetToken}&id=${user.id}`

    await sendMail({
        to: user.email,
        subject: '🔒 Reset Your UrGym Password',
        html: `
        <div style="font-family: Arial, sans-serif; background-color: #f6f7fb; padding: 40px 0; text-align: center;">
            <div style="max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); padding: 30px;">
                <img src="https://res.cloudinary.com/dzbexi0ka/image/upload/v1759994968/attendance-app/logo/UrAttend-logo_t0vbun.png" alt="UrAttend Logo" style="width: 250px; margin-bottom: 20px; margin-top: 20px;" />
                
                <h2 style="color: #D50000; margin-bottom: 10px;">Reset Your Password</h2>
                <p style="color: #444; font-size: 15px; line-height: 1.6;">
                    We received a request to reset your password for your <strong>UrAttend</strong> account.
                    Click the button below to securely create a new password.
                </p>

                <a href="${resetLink}" 
                   style="display:inline-block;margin-top:20px;padding:12px 24px;background-color:#D50000;color:#ffffff;
                   font-weight:bold;text-decoration:none;border-radius:6px;font-size:15px;">
                   Reset Password
                </a>

                <p style="color: #777; font-size: 13px; margin-top: 25px;">
                    This link will expire in <strong>15 minutes</strong> for your security.
                    <br>If you didn’t request a password reset, please ignore this email.
                </p>

                <hr style="border:none;border-top:1px solid #eee;margin:30px 0;">
                
                <p style="color: #999; font-size: 12px;">
                    © ${new Date().getFullYear()} UrGym. All rights reserved.<br>
                    Empowering smarter gym application.
                </p>
            </div>
        </div>
    `,
    })
}
