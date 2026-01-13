'use strict'

/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.addColumn('Bookings', 'UserId', {
            type: Sequelize.INTEGER,
            allowNull: false,
        })
        await queryInterface.addColumn('Bookings', 'GymClassId', {
            type: Sequelize.INTEGER,
            allowNull: false,
        })
    },

    async down(queryInterface, Sequelize) {
        await queryInterface.removeColumn('Bookings', 'UserId')
        await queryInterface.removeColumn('Bookings', 'GymClassId')
    },
}
