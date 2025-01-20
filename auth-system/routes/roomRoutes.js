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

module.exports = router;
