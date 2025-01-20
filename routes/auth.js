const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const authMiddleware = require('../middleware/authMiddleware');
const upload = require('./upload'); // สำหรับการอัปโหลดรูปภาพ

const router = express.Router();

// Secret Key สำหรับ JWT
const SECRET_KEY = 'adminpassword';

// สมัครสมาชิก
router.post('/signup', async (req, res) => {
  const { name, email, password } = req.body;

  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = new User({ name, email, password: hashedPassword });
    await user.save();

    const token = jwt.sign({ id: user._id }, SECRET_KEY, { expiresIn: '1h' });

    res.status(201).json({ message: 'User registered successfully', token });
  } catch (err) {
    console.error('Error during signup:', err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// เข้าสู่ระบบ
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign({ id: user._id }, SECRET_KEY, { expiresIn: '1h' });

    res.status(200).json({ message: 'Login successful', token });
  } catch (err) {
    console.error('Error during login:', err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// ดึงข้อมูลโปรไฟล์
router.get('/profile', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user).select('-password');
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.status(200).json(user);
  } catch (err) {
    console.error('Error fetching profile:', err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// อัปเดตข้อมูลโปรไฟล์
router.put('/profile/update', authMiddleware, async (req, res) => {
  const { name, phone, email, address } = req.body;

  try {
    const updatedData = {};
    if (name) updatedData.name = name;
    if (phone) updatedData.phone = phone;
    if (email) updatedData.email = email;
    if (address) updatedData.address = address;

    const user = await User.findByIdAndUpdate(req.user, updatedData, {
      new: true,
      runValidators: true,
    });

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.status(200).json({
      message: 'Profile updated successfully',
      user,
    });
  } catch (err) {
    console.error('Error updating profile:', err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// อัปโหลดรูปโปรไฟล์
router.post('/profile/upload', authMiddleware, upload.single('profileImage'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'No file uploaded' });
    }

    const user = await User.findByIdAndUpdate(
      req.user,
      { profileImage: `/uploads/${req.file.filename}` },
      { new: true }
    );

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.status(200).json({
      message: 'Profile image updated successfully',
      user,
    });
  } catch (err) {
    console.error('Error uploading profile image:', err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
