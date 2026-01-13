'use strict'

const { hashPassword } = require('../utils/bcrypt')

/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        const adminData = require('../data/admin.data.json').map((el) => {
            delete el.id
            el.password = hashPassword(el.password)
            el.createdAt = new Date()
            el.updatedAt = new Date()

            return el
        })
        await queryInterface.bulkInsert('Users', adminData, {})
    },

    async down(queryInterface, Sequelize) {
        await queryInterface.bulkDelete('Users', null, {})
    },
}
