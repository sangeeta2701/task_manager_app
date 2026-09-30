import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app.colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 6, color: _getStatusColor(task.status)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(task.priority).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(task.priority, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getPriorityColor(task.priority))),
                            ),
                            Text("Due: Today", style: AppTextStyles.caption.copyWith(fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(task.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.subHeading.copyWith(fontSize: 16)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 14, color: AppColors.textLight),
                            const SizedBox(width: 4),
                            Text(task.assignedTo, style: AppTextStyles.caption),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: _getStatusColor(task.status).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                              child: Text(task.status, style: TextStyle(fontSize: 10, color: _getStatusColor(task.status), fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed': return AppColors.completed;
      case 'In Progress': return AppColors.inProgress;
      case 'Discussion Required': return AppColors.discussion;
      default: return AppColors.pending;
    }
  }

  Color _getPriorityColor(String priority) {
    if (priority == 'High') return AppColors.discussion;
    if (priority == 'Medium') return AppColors.pending;
    return AppColors.completed;
  }
}