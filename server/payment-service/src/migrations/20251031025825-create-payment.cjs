'use strict'
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable('Payments', {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER,
            },
            membershipType: {
                allowNull: false,
                type: Sequelize.ENUM('3_months', '6_months', '12_months'),
            },
            amount: {
                allowNull: false,
                type: Sequelize.INTEGER,
            },
            status: {
                allowNull: false,
                defaultValue: 'pending',
                type: Sequelize.ENUM('pending', 'success', 'failed'),
            },
            midtransOrderId: {
                type: Sequelize.STRING,
            },
            midtransTransactionId: {
                type: Sequelize.STRING,
            },
            startDate: {
                type: Sequelize.DATE,
            },
            endDate: {
                type: Sequelize.DATE,
            },
            UserId: {
                allowNull: false,
                type: Sequelize.INTEGER,
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
        await queryInterface.dropTable('Payments')
    },
}
