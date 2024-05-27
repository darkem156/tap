const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const { User } = require('../models/sequelize.js');

async function create(req, res) {
  const { username, password, type } = req.body;
  if(!username || !password) return res.status(400).json({ error: 'Not enough data' })
  const usernameExp = /^[a-zA-Z0-9_]{3,20}$/

  if(!usernameExp.test(username)) return res.status(400).json({ error: 'Invalid username' })

  try {
    if(await User.findOne({ where: { username } })) return res.status(400).json({ error: 'User already exists' })

    const cryptedPassword = await bcrypt.hash(password, 8)
    const user = await User.create({
      username,
      password: cryptedPassword,
      type: type || 'S'
    })
    if(user) return res.status(201).json({ success: true })
  } catch (error) {
    return res.status(500).json({ error })
  }
}

async function get(req, res) {
  const { username, password } = req.body
  if(!username || !password) return res.status(400).json({ error: 'Not enough data' })

  try {
    const user = await User.findOne({ where: { username } })
    if (!user) return res.status(404).json({ error: 'User not found' })
    const passwordCorrect = await bcrypt.compare(password, user.password);

    if(!passwordCorrect) return res.status(403).json({ error: 'Invalid password' })

    const token = jwt.sign({ id: user.id, username: user.username, type: user.type }, 'secret', { expiresIn: '1h' });
    console.log(token)

    return res.status(200).json({ username: user.username, type: user.type, token })
    
  } catch (error) {
    return res.status(500).json({ error })
  }
}

module.exports = { create, get }
