const jwt = require('jsonwebtoken');

function authenticateToken(req, res, next) {
  console.log(req.body)
  const token = req.headers['authorization'];
  if (!token) return res.status(401).json({ error: 'Unauthorized' });

  jwt.verify(token, 'secret', (err, decodedToken) => {
    if (err) return res.status(403).json({ error: 'Invalid token' });

    req.userId = decodedToken.id;
    req.username = decodedToken.username;
    req.type = decodedToken.type;
    next()
  });
}

module.exports = authenticateToken;
