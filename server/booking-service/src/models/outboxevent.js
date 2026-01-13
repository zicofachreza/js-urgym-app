'use strict'
import { Model } from 'sequelize'
export default (sequelize, DataTypes) => {
    class OutboxEvent extends Model {
        static associate(models) {
            // define association here
        }
    }
    OutboxEvent.init(
        {
            eventType: {
                type: DataTypes.STRING,
                allowNull: false,
            },
            payload: {
                type: DataTypes.JSONB,
                allowNull: false,
            },
            status: {
                type: DataTypes.STRING,
                defaultValue: 'PENDING',
            },
            errorMessage: DataTypes.TEXT,
        },
        {
            sequelize,
            modelName: 'OutboxEvent',
            tableName: 'OutboxEvents',
        }
    )
    return OutboxEvent
}
