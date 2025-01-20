const express = require('express');
const Room = require('../models/Room');

const router = express.Router();

// สร้างห้องใหม่
router.post('/', async (req, res) => {
  try {
    const room = new Room(req.body);
    await room.save();
    res.status(201).json(room);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// ดึงข้อมูลห้องทั้งหมด
router.get('/', async (req, res) => {
  try {
    const rooms = await Room.find();
    res.json(rooms);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// API สำหรับจอยห้อง
router.post('/join/:roomId', async (req, res) => {
  try {
    const room = await Room.findById(req.params.roomId);
    if (!room) {
      return res.status(404).json({ message: 'Room not found' });
    }

    // ตรวจสอบว่าผู้ใช้เคยจอยห้องนี้แล้วหรือไม่ (เช็คจากผู้ที่จอยแล้ว)
    if (room.currentParticipants >= room.maxParticipants) {
      return res.status(400).json({ message: 'Room is full' });
    }

    // เพิ่มผู้ใช้งานในห้อง (หากยังไม่จอย)
    if (room.participants.includes(req.user)) {
      return res.status(400).json({ message: 'You have already joined this room' });
    }

    room.currentParticipants += 1; // เพิ่มจำนวนผู้เข้าร่วม
    room.participants.push(req.user); // เพิ่ม User ที่จอยห้อง

    await room.save();
    res.status(200).json({ message: 'Joined successfully', room });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

module.exports = router;
