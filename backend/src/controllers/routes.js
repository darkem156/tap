const router = require('express').Router();
const authMiddleware = require('./authMiddleware.js');
const user = require('./user.js');
const exam = require('./exam.js');

router.post('/signUp', user.create);
router.post('/signIn', user.get);
router.post('/createExam', authMiddleware, exam.create)
router.get('/getExams', authMiddleware, exam.get)
router.post('/sendExam', authMiddleware, exam.verifyAnswers)

module.exports = router
