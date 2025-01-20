const mongoose = require('mongoose');

// สร้าง Schema สำหรับห้อง
const roomSchema = new mongoose.Schema({
  sportName: { type: String, required: true }, // ชื่อกีฬา
  fieldName: { type: String, required: true }, // ชื่อสนาม
  time: { type: String, required: true }, // เวลาที่เล่น
  totalPrice: { type: Number, required: true }, // ราคารวม
  pricePerPerson: { type: Number, required: true }, // ราคาต่อคน
  maxParticipants: { type: Number, required: true }, // จำนวนคนสูงสุด
  currentParticipants: { type: Number, default: 0 }, // จำนวนคนที่เข้าร่วมปัจจุบัน (ค่าเริ่มต้นคือ 0)
  location: { type: String, required: true }, // ตำแหน่งสถานที่
});

// สร้าง Model จาก Schema
const Room = mongoose.model('Room', roomSchema);

module.exports = Room;
