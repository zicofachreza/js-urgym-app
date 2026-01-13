'use strict'
import { Model } from 'sequelize'
export default (sequelize, DataTypes) => {
    class Participant extends Model {
        static associate(models) {
            Participant.belongsTo(models.Conversation, {
                foreignKey: 'ConversationId',
                as: 'conversation',
            })
        }
    }
    Participant.init(
        {
            ConversationId: DataTypes.INTEGER,
            UserId: DataTypes.INTEGER,
            role: DataTypes.STRING,
            joinedAt: {
                type: DataTypes.DATE,
                defaultValue: DataTypes.NOW,
            },
        },
        {
            sequelize,
            modelName: 'Participant',
        }
    )
    return Participant
}
