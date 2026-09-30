import 'package:flutter/material.dart';

class Responsive {
  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  // Responsive value based on screen width
  static double value(BuildContext context, {
    required double mobile,
    double? tablet,
    double? small,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360 && small != null) return small;
    if (width >= 600 && tablet != null) return tablet;
    return mobile;
  }
}