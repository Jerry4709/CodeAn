import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key,this.child});
final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset('assets/images/orange-screen.png',
            fit: BoxFit.cover, //ทำให้ภาพครอบคลุมเต็มพื้นที่หน้าจอ.
            width: double.infinity, //ขยายภาพให้เต็มหน้าจอ.
            height: double.infinity, //ขยายภาพให้เต็มหน้าจอ.
          ),
          SafeArea( //ใช้สำหรับจัดวาง widget ให้อยู่ในพื้นที่ที่ปลอดภัย (ไม่ถูกบังด้วยแถบสถานะหรือขอบจอ).
          child: child!, // ข้อความwelcome
          ),
        ],
      ),
    );
  }
}
