'use strict'
import { Model } from 'sequelize'
export default (sequelize, DataTypes) => {
    class Booking extends Model {
        static associate(models) {
            // define association here
        }
    }
    Booking.init(
        {
            bookingDate: {
                type: DataTypes.DATE,
                allowNull: false,
                validate: {
                    notNull: { msg: 'Booking date is required.' },
                    notEmpty: { msg: 'Booking date is required.' },
                },
            },
            status: {
                type: DataTypes.ENUM('confirmed', 'cancelled'),
                allowNull: false,
                defaultValue: 'confirmed',
            },
            UserId: {
                type: DataTypes.INTEGER,
                unique: 'unique_user_class',
                allowNull: false,
                validate: {
                    notNull: { msg: 'UserId is required.' },
                    notEmpty: { msg: 'UserId is required.' },
                },
            },
            GymClassId: {
                type: DataTypes.INTEGER,
                unique: 'unique_user_class',
                allowNull: false,
                validate: {
                    notNull: { msg: 'GymClassId is required.' },
                    notEmpty: { msg: 'GymClassId is required.' },
                },
            },
            cancelledAt: DataTypes.DATE,
        },
        {
            sequelize,
            modelName: 'Booking',
        }
    )
    return Booking
}
