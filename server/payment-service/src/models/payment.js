'use strict'
import { Model } from 'sequelize'
export default (sequelize, DataTypes) => {
    class Payment extends Model {
        static associate(models) {
            // define association here
        }
    }
    Payment.init(
        {
            membershipType: {
                type: DataTypes.ENUM('3_months', '6_months', '12_months'),
                allowNull: false,
            },
            amount: {
                type: DataTypes.INTEGER,
                allowNull: false,
            },
            status: {
                type: DataTypes.ENUM('pending', 'success', 'failed'),
                defaultValue: 'pending',
            },
            midtransOrderId: DataTypes.STRING,
            midtransTransactionId: DataTypes.STRING,
            snapToken: DataTypes.STRING,
            redirectUrl: DataTypes.STRING,
            startDate: DataTypes.DATE,
            endDate: DataTypes.DATE,
            UserId: {
                type: DataTypes.INTEGER,
                allowNull: false,
            },
        },
        {
            sequelize,
            modelName: 'Payment',
        }
    )
    return Payment
}
