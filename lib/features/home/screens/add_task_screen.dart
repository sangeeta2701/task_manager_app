import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/core/constants/app.colors.dart';
import 'package:task_manager_app/features/home/provider/task_provider.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/models/task_model.dart';


class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  
  String _priority = 'Medium';
  String _category = 'Development';
  String _status = 'Not Started';
  String _assignedTo = 'You';
  String _assignedBy = 'Manager';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _submitTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a title"), backgroundColor: AppColors.discussion),
      );
      return;
    }

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch, // Unique ID
      title: _titleController.text,
      description: _descController.text.isEmpty ? "No description provided." : _descController.text,
      priority: _priority,
      status: _status,
      assignedTo: _assignedTo,
      assignedBy: _assignedBy,
      dueDate: _dueDate,
      category: _category,
    );

    Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Create New Task", style: AppTextStyles.subHeading),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Task Title", "e.g., Review Dashboard Wireframes", _titleController),
            const SizedBox(height: 20),
            _buildTextField("Description", "Enter detailed description...", _descController, maxLines: 4),
            const SizedBox(height: 20),
            
            // Priority & Category
            Row(
              children: [
                Expanded(child: _buildDropdown("Priority", ["High", "Medium", "Low"], _priority, (val) => setState(() => _priority = val!))),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdown("Category", ["Development", "Design", "Testing", "Marketing"], _category, (val) => setState(() => _category = val!))),
              ],
            ),
            const SizedBox(height: 20),

            // Status & Due Date
            Row(
              children: [
                Expanded(child: _buildDropdown("Status", ['Not Started', 'In Progress', 'Completed', 'Discussion Required'], _status, (val) => setState(() => _status = val!))),
                const SizedBox(width: 16),
                Expanded(child: _buildDatePicker(context)),
              ],
            ),
            const SizedBox(height: 20),

            // Assigned To & By
            Row(
              children: [
                Expanded(child: _buildDropdown("Assigned To", ["You", "Manager", "QA Team", "Developer"], _assignedTo, (val) => setState(() => _assignedTo = val!))),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdown("Assigned By", ["Manager", "Client", "Self"], _assignedBy, (val) => setState(() => _assignedBy = val!))),
              ],
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _submitTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  shadowColor: AppColors.primary.withOpacity(0.5),
                ),
                child: const Text("Create Task", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String currentValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              isExpanded: true,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: AppTextStyles.body))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Due Date", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MMM dd, yyyy').format(_dueDate), style: AppTextStyles.body),
                const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}