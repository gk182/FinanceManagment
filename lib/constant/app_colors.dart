import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF3bcaa8); // Màu chính
  static const primary = Color(0xFFB2F5E5);
  static const secondary = Color(0xFFDFF7E2); // Màu phụ
  static const whiteBackground = Color(0xFFF6F6F6); // Màu nền

  static const textPrimary = Color(0xFF00D09E); // Màu chữ chính

  static const OceanBlue = Color(0xFF0068FF); // Màu chữ chính
  static const LightBlue = Color(0xFF6DB6FE); // Màu lỗi
}

// Cách sử dụng:
// import 'package:finance_managment/constant/app_colors.dart';

// Container(
//   color: AppColors.primary,
//   child: Text(
//     'Hello',
//     style: TextStyle(color: AppColors.text),
//   ),
// )