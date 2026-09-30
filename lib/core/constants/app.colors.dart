import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2A9D8F); 
  static const Color primaryDark = Color(0xFF1E7A6F);
  static const Color accent = Color(0xFFE9C46A);
  static const Color background = Color(0xFFF4F7F6); 
  static const Color textDark = Color(0xFF264653);
  static const Color textLight = Color(0xFF7A8B99);
  static const Color white = Colors.white;
  
  // Status Colors
  static const Color pending = Color(0xFFE76F51);
  static const Color inProgress = Color(0xFFF4A261);
  static const Color completed = Color(0xFF2A9D8F);
  static const Color discussion = Color(0xFFE63946);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2A9D8F), Color(0xFF264653)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF2A9D8F), Color(0xFF21867A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}