import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile; // ตัวแปรสำหรับเก็บรูปภาพที่เลือก
  String name = 'John Doe'; // ชื่อเริ่มต้น
  String phone = '081-234-5678'; // เบอร์โทรเริ่มต้น

  // ฟังก์ชันสำหรับเลือกภาพ
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery); // เลือกจากแกลเลอรี

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // อัปเดตรูปภาพ
      });
    }
  }

  // ฟังก์ชันสำหรับแก้ไขข้อมูล (ชื่อหรือเบอร์โทร)
  void _editInfo(String title, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('แก้ไข $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'กรอก$titleใหม่',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // ปิด Dialog
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text); // บันทึกค่าที่แก้ไข
                Navigator.pop(context); // ปิด Dialog
              },
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('บัญชีของฉัน'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ส่วนของรูปโปรไฟล์
            Container(
              color: Colors.orange,
              padding: const EdgeInsets.only(bottom: 30),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!) // รูปที่เลือก
                              : const AssetImage('assets/images/Jazd.jpg')
                          as ImageProvider, // รูปเริ่มต้น
                          backgroundColor: Colors.grey[200],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage, // เปิดฟังก์ชันเลือกภาพ
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name, // ชื่อผู้ใช้
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'johndoe@example.com', // อีเมล
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ส่วนของข้อมูลเพิ่มเติม
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ProfileInfoTile(
                    icon: Icons.person,
                    label: 'ชื่อ',
                    value: name,
                    onTap: () {
                      _editInfo('ชื่อ', name, (newValue) {
                        setState(() {
                          name = newValue; // อัปเดตชื่อใหม่
                        });
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileInfoTile(
                    icon: Icons.phone,
                    label: 'เบอร์โทร',
                    value: phone,
                    onTap: () {
                      _editInfo('เบอร์โทร', phone, (newValue) {
                        setState(() {
                          phone = newValue; // อัปเดตเบอร์โทรใหม่
                        });
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // ปุ่ม Logout
                  ElevatedButton(
                    onPressed: () {
                      // เปลี่ยนหน้าไป WelcomeScreen และเคลียร์ stack
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/welcome', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget สำหรับแสดงข้อมูลโปรไฟล์
class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            if (onTap != null)
              const Icon(Icons.edit, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
