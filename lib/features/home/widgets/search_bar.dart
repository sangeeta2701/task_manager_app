 import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app.colors.dart';
import 'package:task_manager_app/features/home/provider/task_provider.dart';

Widget buildSearchBar(TaskProvider provider) {
    return TextField(
      onChanged: (val) => provider.searchTasks(val),
      decoration: InputDecoration(
        hintText: "Search tasks...",
        prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }