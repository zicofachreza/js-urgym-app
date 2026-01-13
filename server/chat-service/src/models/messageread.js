'use strict'
import { Model } from 'sequelize'
export default (sequelize, DataTypes) => {
    class MessageRead extends Model {
        static associate(models) {
            MessageRead.belongsTo(models.Message, {
                foreignKey: 'MessageId',
                as: 'message',
            })
        }
    }
    MessageRead.init(
        {
            MessageId: DataTypes.INTEGER,
            readerId: DataTypes.INTEGER,
            readAt: DataTypes.DATE,
        },
        {
            sequelize,
            modelName: 'MessageRead',
        }
    )
    return MessageRead
}
