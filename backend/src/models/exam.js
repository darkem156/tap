const { DataTypes } = require('sequelize');

module.exports = {
  id: {
    type: DataTypes.BIGINT,
    allowNull: false,
    autoIncrement: true,
    primaryKey: true
  },
  teacher_id: {
    type: DataTypes.BIGINT,
    references: {
      model: 'users',
      key: 'id'
    },
  },
  name: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  students: {
    type: DataTypes.JSON,
    allowNull: false
  },
  scores: {
    type: DataTypes.JSON,
    defaultValue: {}
  }
};
