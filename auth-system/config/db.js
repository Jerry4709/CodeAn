const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    // เชื่อมต่อ MongoDB โดยใช้ Connection String จาก process.env.MONGO_URI
    await mongoose.connect(process.env.MONGO_URI); // ไม่ต้องใช้ useNewUrlParser หรือ useUnifiedTopology
    console.log('MongoDB Connected...');
  } catch (err) {
    console.error('Error connecting to MongoDB:', err.message);
    process.exit(1); // หยุดการทำงานหากเชื่อมต่อไม่ได้
  }
};

module.exports = connectDB; // ส่งออกฟังก์ชัน connectDB
