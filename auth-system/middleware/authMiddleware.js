const jwt = require('jsonwebtoken');
const User = require('../models/User');

const SECRET_KEY = 'adminpassword';

const authMiddleware = async (req, res, next) => {
  const token = req.header('Authorization')?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ message: 'No token, authorization denied' });
  }

  try {
    const decoded = jwt.verify(token, SECRET_KEY);
    req.user = decoded.id;

    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    next();
  } catch (err) {
    console.error('Error with token verification:', err.message);
    res.status(401).json({ message: 'Token is invalid' });
  }
};

module.exports = authMiddleware;
