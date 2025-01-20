import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'select_location_screen.dart';

class CreateRoomDialog extends StatefulWidget {
  const CreateRoomDialog({Key? key}) : super(key: key);

  @override
  _CreateRoomDialogState createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  final TextEditingController _sportNameController = TextEditingController();
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  int _maxParticipants = 2;
  LatLng? _selectedLocation;
  String? _locationText;

  bool _isLoading = false; // สำหรับแสดงสถานะ Loading

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // กรอบโค้งมน
      ),
      title: const Text(
        'สร้างห้องใหม่',
        style: TextStyle(color: Colors.orange),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ชื่อกีฬา
            TextField(
              controller: _sportNameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อกีฬา',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // ชื่อสนาม
            TextField(
              controller: _fieldNameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อสนาม',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // เวลาเล่น
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'เวลาเล่น (เช่น 2 ชั่วโมง)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // ราคารวมทั้งหมด
            TextField(
              controller: _totalPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ราคารวมทั้งหมด (บาท)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // จำนวนคนสูงสุด
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('จำนวนผู้เข้าร่วมสูงสุด'),
                DropdownButton<int>(
                  value: _maxParticipants,
                  items: List.generate(
                    39,
                        (index) => DropdownMenuItem(
                      value: index + 2,
                      child: Text('${index + 2}'),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _maxParticipants = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ปักหมุด Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Location'),
                TextButton(
                  onPressed: _pickLocation,
                  child: Text(
                    _locationText ?? 'ปักหมุด',
                    style: const TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('ยกเลิก'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createRoom,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('สร้าง'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
        ),
      ],
    );
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectLocationScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
        _locationText =
        'Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(4)}';
      });
    }
  }

  Future<void> _createRoom() async {
    final String sportName = _sportNameController.text.trim();
    final String fieldName = _fieldNameController.text.trim();
    final String time = _timeController.text.trim();
    final String totalPriceText = _totalPriceController.text.trim();

    if (sportName.isEmpty ||
        fieldName.isEmpty ||
        time.isEmpty ||
        totalPriceText.isEmpty ||
        _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

    final double totalPrice = double.tryParse(totalPriceText) ?? 0.0;
    final double pricePerPerson = totalPrice / _maxParticipants;

    final roomData = {
      'sportName': sportName,
      'fieldName': fieldName,
      'time': time,
      'totalPrice': totalPrice,
      'pricePerPerson': pricePerPerson,
      'maxParticipants': _maxParticipants,
      'location': _locationText,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://team-up.up.railway.app/api/rooms'), // แก้ URL ให้ตรงกับเซิร์ฟเวอร์ของคุณ
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(roomData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('สร้างห้องสำเร็จ!')),
        );
        Navigator.of(context).pop(roomData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${response.body}'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $error'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
