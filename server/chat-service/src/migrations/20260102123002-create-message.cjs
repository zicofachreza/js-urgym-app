'use strict'
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable('Messages', {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER,
            },
            ConversationId: {
                allowNull: false,
                references: {
                    model: 'Conversations',
                    key: 'id',
                },
                type: Sequelize.INTEGER,
            },
            senderId: {
                allowNull: false,
                type: Sequelize.INTEGER,
            },
            senderRole: {
                allowNull: false,
                type: Sequelize.STRING,
            },
            content: {
                type: Sequelize.TEXT,
            },
            messageType: {
                defaultValue: 'text',
                type: Sequelize.STRING,
            },
            isDeleted: {
                defaultValue: false,
                type: Sequelize.BOOLEAN,
            },
            createdAt: {
                allowNull: false,
                type: Sequelize.DATE,
            },
            updatedAt: {
                allowNull: false,
                type: Sequelize.DATE,
            },
        })
    },
    async down(queryInterface, Sequelize) {
        await queryInterface.dropTable('Messages')
    },
}
