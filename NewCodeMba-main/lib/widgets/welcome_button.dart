import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.color,
    required this.textColor,
    required this.elevation,        // เพิ่มพารามิเตอร์ elevation
    required this.borderRadius,     // เพิ่มพารามิเตอร์ borderRadius
    required this.borderSide,       // เพิ่มพารามิเตอร์ borderSide
    required this.padding,          // เพิ่มพารามิเตอร์ padding
  });

  final String buttonText;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final double elevation;          // ใช้สำหรับเงาของปุ่ม
  final BorderRadiusGeometry borderRadius; // ใช้สำหรับกำหนดขอบปุ่ม
  final BorderSide borderSide;    // ใช้สำหรับขอบของปุ่ม
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: Border.all(
            color: borderSide.color,      // ใช้สีขอบที่กำหนด
            width: borderSide.width,      // ใช้ความกว้างของขอบที่กำหนด
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: elevation,       // ใช้ความเบลอของเงา
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 18,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
