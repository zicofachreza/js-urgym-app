'use strict'
import { Model } from 'sequelize'
export default (sequelize, DataTypes) => {
    class FailedEvent extends Model {
        static associate(models) {
            // define association here
        }
    }
    FailedEvent.init(
        {
            eventType: {
                type: DataTypes.STRING,
                allowNull: false,
            },
            payload: {
                type: DataTypes.JSONB,
                allowNull: false,
            },
            errorMessage: DataTypes.TEXT,
            retryCount: {
                type: DataTypes.INTEGER,
                defaultValue: 0,
            },
            status: {
                type: DataTypes.STRING,
                defaultValue: 'FAILED',
            },
        },
        {
            sequelize,
            modelName: 'FailedEvent',
        }
    )
    return FailedEvent
}
