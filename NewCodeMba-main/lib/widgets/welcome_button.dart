import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.color,
    required this.textColor,
  });

  final String buttonText; // ข้อความที่จะแสดงบนปุ่ม
  final Widget onTap; // หน้าจอที่ต้องการนำทางเมื่อกดปุ่ม
  final Color color; // สีพื้นหลังของปุ่ม
  final Color textColor; // สีข้อความในปุ่ม

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => onTap, // นำทางไปยังหน้าที่ระบุใน onTap
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(30.0), // ระยะ Padding ของปุ่ม
        decoration: BoxDecoration(
          color: color, // สีพื้นหลังของปุ่ม
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), // มุมโค้งที่มุมซ้ายบน
          ),
        ),
        child: Text(
          buttonText, // ข้อความในปุ่ม
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0, // ขนาดฟอนต์
            fontWeight: FontWeight.bold, // น้ำหนักฟอนต์
            color: textColor, // สีข้อความในปุ่ม
          ),
        ),
      ),
    );
  }
}