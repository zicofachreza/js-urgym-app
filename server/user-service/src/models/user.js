'use strict'
import { Model } from 'sequelize'
import { hashPassword } from '../utils/bcrypt.js'
export default (sequelize, DataTypes) => {
    class User extends Model {
        static associate(models) {
            // define association here
        }
    }
    User.init(
        {
            username: {
                type: DataTypes.STRING,
                allowNull: false,
                validate: {
                    notNull: { msg: 'Username is required.' },
                    notEmpty: { msg: 'Username is required.' },
                    len: {
                        args: [5],
                        msg: 'Username must be at least 5 characters long.',
                    },
                },
                unique: {
                    args: true,
                    msg: 'Username is already used.',
                },
            },
            email: {
                type: DataTypes.STRING,
                allowNull: false,
                validate: {
                    notNull: { msg: 'Email is required.' },
                    notEmpty: { msg: 'Email is required.' },
                    isEmail: { msg: 'Invalid email format.' },
                },
                unique: {
                    args: true,
                    msg: 'Email is already used.',
                },
            },
            password: {
                type: DataTypes.STRING,
                allowNull: false,
                validate: {
                    notNull: { msg: 'Password is required.' },
                    notEmpty: { msg: 'Password is required.' },
                    len: {
                        args: [5],
                        msg: 'Password must be at least 5 characters long.',
                    },
                },
            },
            role: {
                type: DataTypes.STRING,
                defaultValue: 'user',
            },
            isMember: {
                type: DataTypes.BOOLEAN,
                defaultValue: false,
            },
            membershipExpiresAt: DataTypes.DATE,
            resetToken: DataTypes.STRING,
            resetTokenExpires: DataTypes.DATE,
        },
        {
            sequelize,
            modelName: 'User',
            hooks: {
                beforeSave(user) {
                    if (user.changed('password')) {
                        user.password = hashPassword(user.password)
                    }
                },
            },
        }
    )
    return User
}
