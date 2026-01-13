'use strict'
import { Model } from 'sequelize'
export default (sequelize, DataTypes) => {
    class MembershipPlan extends Model {
        static associate(models) {
            // define association here
        }
    }
    MembershipPlan.init(
        {
            type: {
                type: DataTypes.STRING,
                allowNull: false,
                unique: true,
            },
            price: {
                type: DataTypes.INTEGER,
                allowNull: false,
            },
            description: DataTypes.STRING,
        },
        {
            sequelize,
            modelName: 'MembershipPlan',
        }
    )
    return MembershipPlan
}
