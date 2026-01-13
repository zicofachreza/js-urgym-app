'use strict'

/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.bulkInsert('MembershipPlans', [
            {
                type: '3_months',
                price: 300000,
                description: 'Membership is active for 3 months.',
                createdAt: new Date(),
                updatedAt: new Date(),
            },
            {
                type: '6_months',
                price: 550000,
                description: 'Membership is active for 6 months.',
                createdAt: new Date(),
                updatedAt: new Date(),
            },
            {
                type: '12_months',
                price: 1000000,
                description: 'Membership is active for 12 months.',
                createdAt: new Date(),
                updatedAt: new Date(),
            },
        ])
    },

    async down(queryInterface, Sequelize) {
        await queryInterface.bulkDelete('MembershipPlans', null, {})
    },
}
