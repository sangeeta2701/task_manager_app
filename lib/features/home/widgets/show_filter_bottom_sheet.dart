 import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app.colors.dart';
import 'package:task_manager_app/core/constants/app_text_styles.dart';
import 'package:task_manager_app/features/home/provider/task_provider.dart';

void showFilterBottomSheet(BuildContext context, TaskProvider provider) {
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
              Text("Filter by Status", style: AppTextStyles.subHeading),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  'All',
                  'Not Started',
                  'In Progress',
                  'Completed',
                  'Discussion Required',
                ].map((status) {
                  final isSelected = provider.filterStatus == status;
                  return ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (val) {
                      provider.setFilterStatus(status);
                      Navigator.pop(context);
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textDark,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 35,),
            ],
          ),
        );
      },
    );
  }