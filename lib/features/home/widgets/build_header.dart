 import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app.colors.dart';
import 'package:task_manager_app/core/constants/app_text_styles.dart';
import 'package:task_manager_app/features/home/provider/task_provider.dart';

Widget buildHeader(TaskProvider provider) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, Sangeeta!",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.subHeading.copyWith(fontSize: 18),
              ),
              Text(
                "You have ${provider.pendingTasks} tasks today",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.notifications_none, color: AppColors.textDark),
        ),
      ],
    );
  }