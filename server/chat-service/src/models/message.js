'use strict'
import { Model } from 'sequelize'
export default (sequelize, DataTypes) => {
    class Message extends Model {
        static associate(models) {
            Message.belongsTo(models.Conversation, {
                foreignKey: 'ConversationId',
                as: 'conversation',
            })

            Message.hasMany(models.MessageRead, {
                foreignKey: 'MessageId',
                as: 'reads',
            })
        }
    }
    Message.init(
        {
            ConversationId: DataTypes.INTEGER,
            senderId: DataTypes.INTEGER,
            senderRole: DataTypes.STRING,
            content: DataTypes.TEXT,
            messageType: DataTypes.STRING,
            isDeleted: DataTypes.BOOLEAN,
        },
        {
            sequelize,
            modelName: 'Message',
        }
    )
    return Message
}
