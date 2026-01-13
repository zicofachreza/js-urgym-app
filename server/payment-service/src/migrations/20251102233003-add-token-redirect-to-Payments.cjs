'use strict'

/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.addColumn('Payments', 'snapToken', {
            type: Sequelize.STRING,
        })
        await queryInterface.addColumn('Payments', 'redirectUrl', {
            type: Sequelize.STRING,
        })
    },

    async down(queryInterface, Sequelize) {
        await queryInterface.removeColumn('Payments', 'snapToken')
        await queryInterface.removeColumn('Payments', 'redirectUrl')
    },
}
