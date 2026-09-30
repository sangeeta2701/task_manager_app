
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/core/constants/app.colors.dart';
import 'package:task_manager_app/features/home/provider/task_provider.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/models/task_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final int taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  
  void _showDeleteConfirmation(BuildContext context, TaskProvider provider, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.discussion, size: 28),
              const SizedBox(width: 10),
              Text("Delete Task", style: AppTextStyles.subHeading),
            ],
          ),
          content: Text(
            "Are you sure you want to delete \"${task.title}\"? This action cannot be undone.",
            style: AppTextStyles.body.copyWith(color: AppColors.textLight),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textLight,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            // Delete Button
            ElevatedButton(
              onPressed: () {
                // 1. Close the dialog
                Navigator.of(ctx).pop();
                
                // 2. Delete the task via Provider
                provider.deleteTask(task.id);
                
                // 3. Navigate back to Home Screen
                Navigator.of(context).pop();
                
                // 4. Show Success Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("\"${task.title}\" deleted successfully"),
                    backgroundColor: AppColors.discussion,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.discussion,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Delete", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    
    // Safe lookup
    Task? task;
    try {
      task = provider.allTasks.firstWhere((t) => t.id == taskId);
    } catch (e) {
      task = null;
    }

    if (task == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: AppColors.primary, title: const Text("Task Not Found")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: AppColors.textLight),
              const SizedBox(height: 16),
              Text("This task no longer exists.", style: AppTextStyles.subHeading),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Go Back")),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Task Details", style: AppTextStyles.subHeading.copyWith(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        // ✅ NEW: Delete Icon in AppBar
        actions: [
          IconButton(
            onPressed: () => _showDeleteConfirmation(context, provider, task!),
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            tooltip: "Delete Task",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Priority Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getPriorityColor(task!.priority).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text("${task.priority} Priority", style: TextStyle(color: _getPriorityColor(task.priority), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(task.title, style: AppTextStyles.heading),
            const SizedBox(height: 10),
            
            // Description
            Text(task.description, style: AppTextStyles.body.copyWith(color: AppColors.textLight, height: 1.6)),
            const SizedBox(height: 24),

            // Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  _buildInfoRow("Assigned By", task.assignedBy, Icons.person_outline),
                  const Divider(height: 24),
                  _buildInfoRow("Assigned To", task.assignedTo, Icons.person_add_alt),
                  const Divider(height: 24),
                  _buildInfoRow("Due Date", DateFormat('MMM dd, yyyy').format(task.dueDate), Icons.calendar_today),
                  const Divider(height: 24),
                  _buildInfoRow("Category", task.category, Icons.category_outlined),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Status Update
            Text("Update Status", style: AppTextStyles.subHeading),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: task.status,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                  items: ['Not Started', 'In Progress', 'Completed', 'Shared for Testing', 'Discussion Required']
                      .map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                  onChanged: (newValue) {
                    if (newValue != null && newValue != task!.status) {
                      provider.updateTaskStatus(task.id, newValue);
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Status updated to $newValue"), 
                            backgroundColor: AppColors.primary, 
                            behavior: SnackBarBehavior.floating
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.caption),
        const Spacer(),
        Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    if (priority == 'High') return AppColors.discussion;
    if (priority == 'Medium') return AppColors.pending;
    return AppColors.completed;
  }
}