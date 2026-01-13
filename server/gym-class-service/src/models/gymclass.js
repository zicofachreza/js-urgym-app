'use strict'
import { Model } from 'sequelize'
export default (sequelize, DataTypes) => {
    class GymClass extends Model {
        static associate(models) {
            // define association here
        }
    }
    GymClass.init(
        {
            name: {
                type: DataTypes.STRING,
                allowNull: false,
                validate: {
                    notNull: { msg: 'Gym Class name is required.' },
                    notEmpty: { msg: 'Gym class name is required.' },
                },
            },
            instructor: {
                type: DataTypes.STRING,
                allowNull: false,
                validate: {
                    notNull: { msg: 'Instructor is required.' },
                    notEmpty: { msg: 'Instructor is required.' },
                },
            },
            schedule: {
                type: DataTypes.DATE,
                allowNull: false,
                validate: {
                    notNull: { msg: 'Schedule is required.' },
                    notEmpty: { msg: 'Schedule is required.' },
                },
            },
            capacity: {
                type: DataTypes.INTEGER,
                allowNull: false,
                validate: {
                    notNull: { msg: 'Capacity is required.' },
                    notEmpty: { msg: 'Capacity is required.' },
                },
            },
            duration: {
                type: DataTypes.INTEGER,
                allowNull: false,
                validate: {
                    notNull: { msg: 'Duration is required.' },
                    notEmpty: { msg: 'Duration is required.' },
                },
            },
        },
        {
            sequelize,
            modelName: 'GymClass',
        }
    )
    return GymClass
}
