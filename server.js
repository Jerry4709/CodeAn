const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const path = require('path');
const morgan = require('morgan');
const helmet = require('helmet');
const connectDB = require('./config/db'); // นำเข้าโมดูลสำหรับเชื่อมต่อ MongoDB

const app = express();

// เชื่อมต่อฐานข้อมูล MongoDB
connectDB();

// Middleware
app.use(express.json());
app.use(cors());
app.use(morgan('dev'));
app.use(helmet());

// Static Folder สำหรับไฟล์อัปโหลด
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use('/api/auth', require('./routes/auth')); // เชื่อมกับ auth.js
app.use('/api/rooms', require('./routes/roomRoutes')); // เชื่อมกับ roomRoutes.js

// Default Route
app.get('/', (req, res) => {
  res.send('API is running...');
});

// Handle 404 Error
app.use((req, res, next) => {
  res.status(404).json({ message: 'API endpoint not found' });
});

// Global Error Handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Internal Server Error' });
});

// Run Server
const PORT = process.env.PORT || 5001;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
