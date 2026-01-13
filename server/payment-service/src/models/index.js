'use strict'

import fs from 'fs'
import path from 'path'
import { fileURLToPath, pathToFileURL } from 'url'
import Sequelize from 'sequelize'
import process from 'process'
import configFile from '../config/config.js'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const basename = path.basename(__filename)
const env = process.env.NODE_ENV || 'development'
const config = configFile[env]
const db = {}

let sequelize
if (config.use_env_variable) {
    sequelize = new Sequelize.Sequelize(
        process.env[config.use_env_variable],
        config
    )
} else {
    sequelize = new Sequelize.Sequelize(
        config.database,
        config.username,
        config.password,
        config
    )
}

const modelFiles = fs
    .readdirSync(__dirname)
    .filter(
        (file) =>
            file.indexOf('.') !== 0 &&
            file !== basename &&
            file.slice(-3) === '.js' &&
            !file.endsWith('.test.js')
    )

for (const file of modelFiles) {
    const filePath = path.join(__dirname, file)
    const fileUrl = pathToFileURL(filePath).href
    const { default: modelDefiner } = await import(fileUrl)
    const model = modelDefiner(sequelize, Sequelize.DataTypes)
    db[model.name] = model
}

Object.keys(db).forEach((modelName) => {
    if (db[modelName].associate) db[modelName].associate(db)
})

db.sequelize = sequelize
db.Sequelize = Sequelize

export { sequelize }
export default db
