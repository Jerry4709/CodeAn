const express = require('express');
const mongoose = require('mongoose');

const app = express();

// Connection String ตรง (กรอกข้อมูลจริง)
const MONGO_URI = "mongodb+srv://jimmy551:1231123123ZZZZZ@test.rndif.mongodb.net/Test?retryWrites=true&w=majority";

// ฟังก์ชันสำหรับเชื่อมต่อ MongoDB
const connectDB = async () => {
  try {
    // เชื่อมต่อ MongoDB โดยตรง
    await mongoose.connect(MONGO_URI, {
      useNewUrlParser: true, // ใช้สำหรับ MongoDB Driver เก่า
      useUnifiedTopology: true // ใช้สำหรับ MongoDB Driver เก่า
    });
    console.log('MongoDB Connected...');
  } catch (err) {
    console.error('Error connecting to MongoDB:', err.message);
    process.exit(1); // หยุดเซิร์ฟเวอร์หากเชื่อมต่อไม่ได้
  }
};

// เชื่อมต่อ MongoDB
connectDB();

// Middleware สำหรับจัดการ JSON
app.use(express.json());

// Debug Route Middleware
app.use('/api/auth', (req, res, next) => {
  console.log('Route /api/auth accessed'); // Debug: แสดงเมื่อมีการเข้าถึง /api/auth
  next();
});

// เชื่อมต่อ Routes (API สำหรับ Authentication)
app.use('/api/auth', require('./routes/auth'));

// ตัวอย่าง Route ทดสอบ
app.get('/', (req, res) => {
  console.log('GET / accessed'); // Debug: แสดงเมื่อมีการเข้าถึง /
  res.send('Server is running...');
});

// กำหนด PORT ตรง
const PORT = 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
