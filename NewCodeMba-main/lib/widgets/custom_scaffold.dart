import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // ใช้ Navigator.pop เพื่อย้อนกลับไปหน้าก่อนหน้า
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/orange-screen.png',
            fit: BoxFit.cover, // ทำให้ภาพครอบคลุมเต็มพื้นที่หน้าจอ
            width: double.infinity, // ขยายภาพให้เต็มหน้าจอ
            height: double.infinity, // ขยายภาพให้เต็มหน้าจอ
          ),
          SafeArea(
            child: child!, // ข้อความ welcome
          ),
        ],
      ),
    );
  }
}
