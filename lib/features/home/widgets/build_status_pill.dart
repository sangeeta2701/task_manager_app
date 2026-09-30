import 'package:flutter/material.dart';

Widget buildStatPill(IconData icon, String label, int count, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: color.withOpacity(0.25), width: 1),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "$count",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color.withOpacity(0.85),
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
        ),
      ],
    ),
  );
}