import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app.colors.dart';
import 'package:task_manager_app/core/constants/app_text_styles.dart';
import 'package:task_manager_app/features/home/provider/task_provider.dart';

void showSortBottomSheet(BuildContext context, TaskProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sort by", style: AppTextStyles.subHeading),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.priority_high),
                title: const Text("Priority"),
                trailing: provider.sortOption == SortOption.priority
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  provider.setSortOption(SortOption.priority);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text("Due Date"),
                trailing: provider.sortOption == SortOption.dueDate
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  provider.setSortOption(SortOption.dueDate);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort),
                title: const Text("Status"),
                trailing: provider.sortOption == SortOption.status
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  provider.setSortOption(SortOption.status);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }