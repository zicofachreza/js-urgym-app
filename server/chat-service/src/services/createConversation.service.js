import db from '../models/index.js'
const { Conversation, Participant } = db

export const createConversationWithAdmin = async (userId, adminId) => {
    const convo = await Conversation.create({
        UserId: userId,
        status: 'open',
    })

    await Participant.bulkCreate([
        {
            ConversationId: convo.id,
            UserId: userId,
            role: 'user',
        },
        {
            ConversationId: convo.id,
            UserId: adminId,
            role: 'admin',
        },
    ])

    return convo
}
