'use strict'

const { hashPassword } = require('../utils/bcrypt')

/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        const existingAdmin = await queryInterface.sequelize.query(
            `
            SELECT id
            FROM "Users"
            WHERE role = 'admin'
            LIMIT 1;
            `,
            { type: Sequelize.QueryTypes.SELECT }
        )

        if (existingAdmin.length > 0) {
            console.log('Admin user already exists, skipping seeder...')
            return
        }

        const adminData = require('../data/admin.data.json').map((el) => {
            delete el.id
            el.password = hashPassword(el.password)
            el.createdAt = new Date()
            el.updatedAt = new Date()

            return el
        })
        await queryInterface.bulkInsert('Users', adminData, {})
    },

    async down() {},
}
