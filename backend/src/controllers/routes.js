const router = require('express').Router();
const authMiddleware = require('./authMiddleware.js');
const user = require('./user.js');
const exam = require('./exam.js');
const assistance = require('./assistance.js');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const dir = './src/uploads';
    if (!fs.existsSync(dir)){
      fs.mkdirSync(dir);
    }
    cb(null, dir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });

router.post('/signUp', user.create);
router.post('/signIn', user.get);
router.post('/createExam', authMiddleware, exam.create)
router.get('/getExams', authMiddleware, exam.get)
router.post('/sendExam', authMiddleware, exam.verifyAnswers)
router.post('/gallery', authMiddleware, upload.array('images', 10), (req, res) => {
  res.status(201).json({ files: req.files.map(file => `${req.protocol}://${req.get('host')}/uploads/${file.filename}`) })
})
router.get('/gallery', (req, res) => {
  fs.readdir('./src/uploads', (err, files) => {
    res.json(files)
  })
})
router.post('/createAssistance', authMiddleware, assistance.create)
router.get('/getAssistance', assistance.get)

module.exports = router
