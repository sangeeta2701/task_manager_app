import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/core/constants/app.colors.dart';
import 'package:task_manager_app/features/home/provider/task_provider.dart';
import 'package:task_manager_app/features/home/screens/add_task_screen.dart';
import 'package:task_manager_app/features/home/widgets/status_card.dart';
import '../../../core/constants/app_text_styles.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: AppColors.primary),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.textLight),
              onPressed: () {},
            ),
            const SizedBox(width: 40), // Space for FAB
            IconButton(
              icon: const Icon(Icons.filter_list, color: AppColors.textLight),
              onPressed: () => _showFilterBottomSheet(context, provider),
            ),
            IconButton(
              icon: const Icon(Icons.person, color: AppColors.textLight),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, Sangeeta!",
                        style: AppTextStyles.subHeading.copyWith(fontSize: 18),
                      ),
                      Text(
                        "You have ${provider.pendingTasks} tasks today",
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10,
              ),
              child: TextField(
                onChanged: (val) => provider.searchTasks(val),
                decoration: InputDecoration(
                  hintText: "Search tasks...",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textLight,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            // Today's Focus Banner
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.today, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Focus",
                          style: AppTextStyles.subHeading.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Project X Deadline | Urgent",
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),

            // Stats Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatsCard(
                    title: "Total",
                    count: provider.totalTasks,
                    color: AppColors.primary,
                    icon: Icons.list_alt,
                  ),
                  StatsCard(
                    title: "Pending",
                    count: provider.pendingTasks,
                    color: AppColors.pending,
                    icon: Icons.pending_actions,
                  ),
                  StatsCard(
                    title: "Done",
                    count: provider.completedTasks,
                    color: AppColors.completed,
                    icon: Icons.check_circle_outline,
                  ),
                  StatsCard(
                    title: "Active",
                    count: provider.inProgressTasks,
                    color: AppColors.inProgress,
                    icon: Icons.timelapse,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Recent Tasks Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Recent Tasks", style: AppTextStyles.subHeading),
                  TextButton.icon(
                    onPressed: () => _showSortBottomSheet(context, provider),
                    icon: const Icon(
                      Icons.sort,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    label: Text(
                      provider.sortOption.name.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Task List
            Expanded(child: _buildTaskList(provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(TaskProvider provider) {
    if (provider.isLoading)
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    if (provider.tasks.isEmpty)
      return Center(child: Text("No tasks found", style: AppTextStyles.body));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      itemCount: provider.tasks.length,
      itemBuilder: (context, index) {
        final task = provider.tasks[index];
        return TaskCard(
          task: task,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskDetailScreen(taskId: task.id),
            ),
          ),
        );
      },
    );
  }

  // --- Bottom Sheets for Filter & Sort ---

  void _showFilterBottomSheet(BuildContext context, TaskProvider provider) {
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
                children:
                    [
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
            ],
          ),
        );
      },
    );
  }

  void _showSortBottomSheet(BuildContext context, TaskProvider provider) {
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
}
