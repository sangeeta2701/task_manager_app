import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app.colors.dart';
import 'package:task_manager_app/core/constants/app_text_styles.dart';
import 'package:task_manager_app/features/home/provider/task_provider.dart';
import 'package:task_manager_app/features/home/widgets/build_status_pill.dart';

Widget buildStatsGrid(TaskProvider provider) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       Text("Tasks Overview", style: AppTextStyles.subHeading),
       SizedBox(height: 8,),
      Row(
        children: [
          Expanded(
            child: buildStatPill(
              Icons.list_alt, "Total", provider.totalTasks, AppColors.primary,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: buildStatPill(
              Icons.pending_actions, "Pending ", provider.pendingTasks, AppColors.pending,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: buildStatPill(
              Icons.check_circle_outline, "Done", provider.completedTasks, AppColors.completed,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: buildStatPill(
              Icons.timelapse, "Active", provider.inProgressTasks, AppColors.inProgress,
            ),
          ),
        ],
      ),
    ],
  );
}