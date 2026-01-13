'use strict'

/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.bulkInsert('GymClasses', [
            {
                name: 'Yoga',
                instructor: 'Lina',
                schedule: '2025-10-30T09:00:00Z',
                capacity: 20,
                duration: 60,
                createdAt: new Date(),
                updatedAt: new Date(),
            },
            {
                name: 'Boxing',
                instructor: 'Joshua',
                schedule: '2025-10-30T09:00:00Z',
                capacity: 20,
                duration: 60,
                createdAt: new Date(),
                updatedAt: new Date(),
            },
            {
                name: 'Cardio Dance',
                instructor: 'Angel',
                schedule: '2025-10-30T09:00:00Z',
                capacity: 20,
                duration: 60,
                createdAt: new Date(),
                updatedAt: new Date(),
            },
        ])
    },

    async down(queryInterface, Sequelize) {
        await queryInterface.bulkDelete('GymClasses', null, {})
    },
}
