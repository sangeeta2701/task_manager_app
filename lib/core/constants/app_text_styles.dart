import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager_app/core/constants/app.colors.dart';


class AppTextStyles {
  static TextStyle heading = GoogleFonts.poppins(
    fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark,
  );
  static TextStyle subHeading = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark,
  );
  static TextStyle body = GoogleFonts.poppins(
    fontSize: 14, color: AppColors.textDark,
  );
  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12, color: AppColors.textLight,
  );
}