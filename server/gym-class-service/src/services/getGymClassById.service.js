'use strict'

import db from '../models/index.js'

const { GymClass } = db

export const getGymClassById = async (GymClassId) => {
    const gymClass = await GymClass.findByPk(GymClassId)
    if (!gymClass) throw { name: 'GymClassNotFound' }

    return gymClass
}
