'use strict'

/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        const existing = await queryInterface.sequelize.query(
            `
            SELECT id
            FROM "GymClasses"
            LIMIT 1;
            `,
            { type: Sequelize.QueryTypes.SELECT }
        )

        if (existing.length > 0) {
            console.log('GymClasses already seeded, skipping...')
            return
        }

        const gymClassData = require('../data/gymClass.data.json').map((el) => {
            delete el.id
            el.createdAt = new Date()
            el.updatedAt = new Date()

            return el
        })
        await queryInterface.bulkInsert('GymClasses', gymClassData, {})
    },

    async down() {},
}
