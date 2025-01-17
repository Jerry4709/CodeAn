const express = require('express');
const router = express.Router(); // เพิ่มการประกาศ router

const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Route สำหรับสมัครสมาชิก
router.post('/signup', async (req, res) => {
  console.log('POST /signup called');
  console.log('Request Body:', req.body);

  const { name, email, password } = req.body;

  try {
    // ตรวจสอบว่าอีเมลมีอยู่แล้วหรือไม่
    let user = await User.findOne({ email });
    if (user) {
      console.log('Email already exists');
      return res.status(400).json({ message: 'Email already exists' });
    }

    // เข้ารหัสรหัสผ่าน
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // สร้างผู้ใช้ใหม่
    user = new User({ name, email, password: hashedPassword });
    await user.save();

    // สร้าง JWT Token
    const token = jwt.sign({ id: user.id }, 'your_jwt_secret', { expiresIn: '1h' });

    console.log('User registered successfully');
    res.status(201).json({ message: 'User registered successfully', token });
  } catch (err) {
    console.error('Error in /signup:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router; // ส่งออก router
