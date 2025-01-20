const mongoose = require('mongoose');

// สร้าง Schema สำหรับห้อง
const roomSchema = new mongoose.Schema({
  sportName: { type: String, required: true },
  fieldName: { type: String, required: true },
  time: { type: String, required: true },
  totalPrice: { type: Number, required: true },
  pricePerPerson: { type: Number, required: true },
  maxParticipants: { type: Number, required: true },
  location: { type: String, required: true },
});

// สร้าง Model จาก Schema
const Room = mongoose.model('Room', roomSchema);

module.exports = Room;
