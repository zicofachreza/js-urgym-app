'use strict'
import { Model } from 'sequelize'
export default (sequelize, DataTypes) => {
    class Conversation extends Model {
        static associate(models) {
            Conversation.hasMany(models.Participant, {
                foreignKey: 'ConversationId',
                as: 'participants',
            })

            Conversation.hasMany(models.Message, {
                foreignKey: 'ConversationId',
                as: 'messages',
            })
        }
    }
    Conversation.init(
        {
            UserId: DataTypes.INTEGER,
            status: {
                type: DataTypes.ENUM('open', 'closed'),
                allowNull: false,
                defaultValue: 'open',
            },
            lastMessageAt: DataTypes.DATE,
        },
        {
            sequelize,
            modelName: 'Conversation',
        }
    )
    return Conversation
}
