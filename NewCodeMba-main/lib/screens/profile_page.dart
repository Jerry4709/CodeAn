import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:team_up/screens/welcome_screen.dart';

class ProfilePage extends StatefulWidget {
  final String token; // รับ Token จากหน้าก่อนหน้า
  const ProfilePage({super.key, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile; // ตัวแปรสำหรับเก็บรูปภาพที่เลือก
  String name = ''; // ชื่อผู้ใช้
  String phone = ''; // เบอร์โทรศัพท์
  String email = ''; // อีเมล
  String address = ''; // ที่อยู่
  String profileImage = ''; // URL ของรูปโปรไฟล์
  bool isLoading = true; // ใช้สำหรับแสดงสถานะโหลดข้อมูล
  String errorMessage = ''; // ข้อความแสดงข้อผิดพลาด

  // ฟังก์ชันสำหรับดึงข้อมูลผู้ใช้จาก API
  Future<void> fetchUserData() async {
    final String apiUrl = 'https://team-up.up.railway.app/api/auth/profile'; // API สำหรับดึงข้อมูลโปรไฟล์
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer ${widget.token}'}, // ส่ง Token ใน Header
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          name = data['name'] ?? 'No name';
          phone = data['phone'] ?? 'No phone';
          email = data['email'] ?? 'No email';
          address = data['address'] ?? 'No address';
          profileImage = data['profileImage'] ?? ''; // เพิ่มการดึง URL รูปภาพ
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load profile data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error connecting to server';
        isLoading = false;
      });
    }
  }

  // ฟังก์ชันสำหรับอัปเดตข้อมูลในฐานข้อมูล
  Future<void> updateUserData(String field, String value) async {
    final String apiUrl = 'https://team-up.up.railway.app/api/auth/profile/update'; // API สำหรับอัปเดตข้อมูลโปรไฟล์
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({field: value}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error connecting to server')),
      );
    }
  }

  // ฟังก์ชันสำหรับอัปโหลดภาพโปรไฟล์
  Future<void> uploadProfileImage(File imageFile) async {
    final String apiUrl = 'https://team-up.up.railway.app/api/auth/profile/upload';
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers['Authorization'] = 'Bearer ${widget.token}'
        ..files.add(await http.MultipartFile.fromPath('profileImage', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image updated successfully')),
        );
        await fetchUserData(); // ดึงข้อมูลผู้ใช้ใหม่เพื่ออัปเดตรูป
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile image')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error uploading image')),
      );
    }
  }

  // ฟังก์ชันสำหรับเปลี่ยนรหัสผ่าน
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final String apiUrl = 'https://team-up.up.railway.app/api/auth/profile/change-password'; // API สำหรับเปลี่ยนรหัสผ่าน
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating password')),
      );
    }
  }

  // Dialog สำหรับเปลี่ยนรหัสผ่าน
  void _changePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final newPasswordConfirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordConfirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text.trim() ==
                    newPasswordConfirmController.text.trim()) {
                  changePassword(
                    currentPasswordController.text.trim(),
                    newPasswordController.text.trim(),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserData(); // ดึงข้อมูลเมื่อหน้าโหลด
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
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
                              ? FileImage(_imageFile!)
                              : (profileImage.isNotEmpty
                              ? NetworkImage(
                              'https://team-up.up.railway.app$profileImage')
                              : const AssetImage(
                              'assets/images/default_avatar.png'))
                          as ImageProvider,
                          backgroundColor: Colors.grey[200],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery);

                              if (pickedFile != null) {
                                setState(() {
                                  _imageFile = File(pickedFile.path);
                                });
                                await uploadProfileImage(_imageFile!);
                              }
                            },
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
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      email,
                      style: const TextStyle(
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
                    label: 'Name',
                    value: name,
                    onTap: () {
                      _editInfo('Name', name, (newValue) {
                        setState(() {
                          name = newValue;
                        });
                        updateUserData('name', newValue);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileInfoTile(
                    icon: Icons.phone,
                    label: 'Tel',
                    value: phone,
                    onTap: () {
                      _editInfo('Phone', phone, (newValue) {
                        setState(() {
                          phone = newValue;
                        });
                        updateUserData('phone', newValue);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileInfoTile(
                    icon: Icons.email,
                    label: 'Email',
                    value: email,
                    onTap: () {
                      _editInfo('Email', email, (newValue) {
                        setState(() {
                          email = newValue;
                        });
                        updateUserData('email', newValue);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileInfoTile(
                    icon: Icons.home,
                    label: 'Address',
                    value: address,
                    onTap: () {
                      _editInfo('Address', address, (newValue) {
                        setState(() {
                          address = newValue;
                        });
                        updateUserData('address', newValue);
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // ปุ่ม Change Password
                  ElevatedButton.icon(
                    onPressed: _changePasswordDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.lock, color: Colors.white),
                    label: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // ปุ่ม Logout
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.exit_to_app, color: Colors.white),
                    label: const Text(
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

  // ฟังก์ชันสำหรับแสดง Dialog แก้ไขข้อมูล
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
              border: const OutlineInputBorder(),
              labelText: 'กรอก$titleใหม่',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  onSave(controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
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
