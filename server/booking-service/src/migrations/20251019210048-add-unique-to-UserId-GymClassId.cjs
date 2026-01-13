'use strict'

/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.addConstraint('Bookings', {
            fields: ['UserId', 'GymClassId'],
            type: 'unique',
            name: 'unique_user_class',
        })
    },

    async down(queryInterface, Sequelize) {
        await queryInterface.removeConstraint('Bookings', 'unique_user_class')
    },
}
