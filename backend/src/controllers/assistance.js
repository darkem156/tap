const jwt = require('jsonwebtoken');
const { Assistance, query } = require('../models/sequelize.js');

async function create(req, res) {
  const { name, content } = req.body
  if(req.type == 'S') return res.status(403).json({ error: '' })
  const { data } = req.body
  if(!name || !content) return res.status(400).json({ error: '' })

  try {
    const assistance = await Assistance.create({
      teacher_id: req.userId,
      name,
      content,
    });

    if (assistance) return res.status(201).json({ assistance });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

async function get(req, res) {
  const exams = await Assistance.findAll()
  return res.status(200).json(exams)
  /*
  if(req.type == 'S') {
    try {
      const exams = await query(`SELECT * from assistance where json_contains(students, '"${req.username}"')`)
      return res.status(200).json(exams[0])
    } catch (error) {
      return res.status(500).json({ error })
    }
  }
  const exams = await Exam.findAll({ where: { teacher_id: req.userId } })
  return res.status(200).json(exams)
  */
}

module.exports = { create, get }
