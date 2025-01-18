const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User'); // นำเข้า User model
const router = express.Router();

// Route สำหรับสมัครสมาชิก
router.post('/signup', async (req, res) => {
  const { name, email, password } = req.body;

  // ตรวจสอบว่าอีเมลมีอยู่ใน MongoDB หรือไม่
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    return res.status(400).json({ message: 'Email already exists' });
  }

  try {
    // เข้ารหัสรหัสผ่าน
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // สร้างผู้ใช้ใหม่ใน MongoDB
    const user = new User({ name, email, password: hashedPassword });
    await user.save();

    // สร้าง JWT Token
    const token = jwt.sign({ id: user._id }, 'adminpassword', { expiresIn: '1h' });

    res.status(201).json({ message: 'User registered successfully', token });
  } catch (err) {
    console.error('Error in /signup:', err.message);
    res.status(500).send('Server error');
  }
});

// Route สำหรับเข้าสู่ระบบ
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    // เปรียบเทียบรหัสผ่าน
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    // สร้าง JWT Token
    const token = jwt.sign({ id: user._id }, 'your_jwt_secret', { expiresIn: '1h' });

    res.status(200).json({ message: 'Login successful', token });
  } catch (err) {
    console.error('Error in /login:', err.message);
    res.status(500).send('Server error');
  }
});

// Route สำหรับข้อมูลโปรไฟล์ (ต้องเข้าสู่ระบบ)
const authMiddleware = require('../middleware/authMiddleware'); // นำเข้า authMiddleware
router.get('/profile', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user).select('-password');
    res.json(user);
  } catch (err) {
    console.error('Error in /profile:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;
