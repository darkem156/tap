const express = require('express');
const cors = require('cors');
const morgan = require('morgan');

const app = express();

//settings
app.set('port', process.env.PORT || 3000);

//middlewares
app.use(cors())
app.use(morgan('dev'));
app.use(express.json());

//routes
app.use('/api', require('./controllers/routes.js'));

module.exports = app;
