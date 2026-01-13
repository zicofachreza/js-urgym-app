'use strict'
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable('MessageReads', {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER,
            },
            MessageId: {
                allowNull: false,
                references: {
                    model: 'Messages',
                    key: 'id',
                },
                type: Sequelize.INTEGER,
            },
            readerId: {
                allowNull: false,
                type: Sequelize.INTEGER,
            },
            readAt: {
                type: Sequelize.DATE,
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
        await queryInterface.dropTable('MessageReads')
    },
}
