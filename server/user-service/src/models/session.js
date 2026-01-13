'use strict'
import { Model } from 'sequelize'
export default (sequelize, DataTypes) => {
    class Session extends Model {
        static associate(models) {
            Session.belongsTo(models.User, { foreignKey: 'UserId' })
        }
    }
    Session.init(
        {
            id: {
                type: DataTypes.UUID,
                defaultValue: DataTypes.UUIDV4,
                primaryKey: true,
            },
            hashedToken: {
                type: DataTypes.STRING,
                allowNull: false,
            },
            deviceInfo: DataTypes.STRING,
            expiresAt: {
                type: DataTypes.DATE,
                allowNull: false,
            },
            ipAddress: DataTypes.STRING,
            lastUsedAt: DataTypes.DATE,
            UserId: {
                type: DataTypes.INTEGER,
                allowNull: false,
            },
        },
        {
            sequelize,
            modelName: 'Session',
        }
    )
    return Session
}
