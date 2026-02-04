'use strict'

import db from '../models/index.js'

const { GymClass } = db

export const getAllGymClasses = async () => {
    const gymClasses = await GymClass.findAll()

    if (!gymClasses || gymClasses.length === 0) {
        throw { name: 'GymClassNotYet' }
    }

    return gymClasses
}
