'use strict'

/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        const existing = await queryInterface.sequelize.query(
            `
            SELECT id
            FROM "MembershipPlans"
            LIMIT 1;
            `,
            { type: Sequelize.QueryTypes.SELECT }
        )

        if (existing.length > 0) {
            console.log('Membership Plans already seeded, skipping...')
            return
        }

        const membershipData = require('../data/membership.data.json').map(
            (el) => {
                delete el.id
                el.createdAt = new Date()
                el.updatedAt = new Date()

                return el
            }
        )
        await queryInterface.bulkInsert('MembershipPlans', membershipData, {})
    },

    async down() {},
}
