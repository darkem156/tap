const jwt = require('jsonwebtoken');
const { Exam, query } = require('../models/sequelize.js');

async function create(req, res) {
  const { name, content, students } = req.body
  if(!name || !content || !students) return res.status(400).json({ error: 'Not enough data' })
  console.log(req.body)
  try {
    const exam = Exam.create({ teacher_id: req.userId, name, content, students })
    if(exam) return res.status(201).json({ exam })
  } catch (error) {
    return res.status(500).json({ error })
  }
}

async function get(req, res) {
  if(req.type == 'S') {
    try {
      const exams = await query(`SELECT * from exams where json_contains(students, '"${req.username}"')`)
      return res.status(200).json(exams[0])
    } catch (error) {
      return res.status(500).json({ error })
    }
  }
  const exams = await Exam.findAll({ where: { teacher_id: req.userId } })
  return res.status(200).json(exams)
}

async function verifyAnswers(req, res) {
  const { answers, id } = req.body;
  if(!answers) return res.status(400).json({ error: 'Not answers' })
  try {
    const entry = await Exam.findOne({ where: { id } })
    const exam = entry.dataValues

    if (exam.scores[req.username] !== undefined) return res.status(400).json({ error: 'Exam already sent' })

    let lastQuestion = ""
    let totalQuestions = 0
    const correctAnswers = {}
    exam.content.split('\n').map(text => {
      if(text[0] == "*") {
        correctAnswers[text.substring(1)] = ""
        lastQuestion = text.substring(1)
        totalQuestions++
      }
      else if(text[0] == "-") correctAnswers[lastQuestion] = text.substring(1)
    })
    let score = 0
    answers.map(([question, answer]) => {
      if (correctAnswers[question] == answer) score += 1
    })
    score = score / totalQuestions * 100
    const newScores = { ...entry.scores, [req.username]: score }
    entry.scores = newScores
    await entry.save()
    return res.status(200).json({ score })
  } catch (error) {
    return res.status(500).json({ error })
  }
}

module.exports = { create, get, verifyAnswers }
