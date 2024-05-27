const { Sequelize } = require('sequelize');
const user = require('./user.js');
const exam = require('./exam.js');
const assistance = require('./assistance.js');

const host = process.env.DB_HOST || 'localhost'
const username = process.env.DB_USER || 'root'
const password = process.env.DB_PASSWORD || 'password'
const database = process.env.DB_DATABASE || 'tap'

const sequelize = new Sequelize(database, username, password, {
  host: host,
  dialect: 'mysql'
})

const User = sequelize.define('user', user)
const Exam = sequelize.define('exam', exam)
const Assistance = sequelize.define('assistance', assistance)

;(async () =>
{
  await sequelize.sync()  
})()

const query = async query => sequelize.query(query);

module.exports = { User, Exam, query }
