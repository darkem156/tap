const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const path = require('path')
bodyParser = require('body-parser');

const app = express();

//settings
app.set('port', process.env.PORT || 3000);
app.use(bodyParser.json({limit: '50mb'}));
app.use(bodyParser.urlencoded({extended: true, limit: '50mb'}));

//middlewares
app.use(cors())
app.use(morgan('dev'));
app.use(express.json());

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

//routes
app.use('/api', require('./controllers/routes.js'));

module.exports = app;
