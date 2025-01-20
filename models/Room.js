const mongoose = require('mongoose');

// สร้าง Schema สำหรับห้อง
const roomSchema = new mongoose.Schema({
  sportName: { type: String, required: true },
  fieldName: { type: String, required: true },
  time: { type: String, required: true },
  totalPrice: { type: Number, required: true },
  pricePerPerson: { type: Number, required: true },
  maxParticipants: { type: Number, required: true },
  currentParticipants: { type: Number, default: 0 },
  location: { type: String, required: true },
  participants: { type: [String], default: [] }, // รายชื่อผู้ที่จอยห้อง
});

const Room = mongoose.model('Room', roomSchema);

module.exports = Room;
