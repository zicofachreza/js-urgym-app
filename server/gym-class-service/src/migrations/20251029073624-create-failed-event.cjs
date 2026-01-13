'use strict'
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable('FailedEvents', {
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
            errorMessage: {
                type: Sequelize.TEXT,
            },
            retryCount: {
                defaultValue: 0,
                type: Sequelize.INTEGER,
            },
            status: {
                defaultValue: 'FAILED',
                type: Sequelize.STRING,
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
        await queryInterface.dropTable('FailedEvents')
    },
}
