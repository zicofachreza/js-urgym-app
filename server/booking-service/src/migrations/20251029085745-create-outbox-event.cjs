'use strict'
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable('OutboxEvents', {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER,
            },
            eventType: {
                allowNull: false,
                type: Sequelize.STRING,
            },
            payload: {
                allowNull: false,
                type: Sequelize.JSONB,
            },
            status: {
                defaultValue: 'PENDING',
                type: Sequelize.STRING,
            },
            errorMessage: {
                type: Sequelize.TEXT,
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
        await queryInterface.dropTable('OutboxEvents')
    },
}
