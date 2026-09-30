import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/core/constants/app.colors.dart';
import 'package:task_manager_app/features/home/provider/task_provider.dart';
import 'package:task_manager_app/features/home/widgets/build_header.dart';
import 'package:task_manager_app/features/home/widgets/build_status_grid.dart';
import 'package:task_manager_app/features/home/widgets/build_todays_focus.dart';
import 'package:task_manager_app/features/home/widgets/search_bar.dart';
import 'package:task_manager_app/features/home/widgets/show_filter_bottom_sheet.dart';
import 'package:task_manager_app/features/home/widgets/show_short_bottom_sheet.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';
import 'add_task_screen.dart';

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
    final horizontalPadding = Responsive.value(
      context,
      small: 16.0,
      mobile: 24.0,
      tablet: 40.0,
    );

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
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.filter_list, color: AppColors.textLight),
              onPressed: () => showFilterBottomSheet(context, provider),
            ),
            IconButton(
              icon: const Icon(Icons.person, color: AppColors.textLight),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => provider.loadTasks(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ---------- HEADER ----------
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 20, horizontalPadding, 10),
                  child: buildHeader(provider),
                ),
              ),

              // ---------- SEARCH BAR ----------
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: 10),
                  child: buildSearchBar(provider),
                ),
              ),

              // ---------- TODAY'S FOCUS ----------
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: 10),
                  child: buildTodaysFocus(),
                ),
              ),

              // ---------- STATS ROW----------
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: buildStatsGrid(provider),
                ),
              ),

              // ---------- RECENT TASKS HEADER ----------
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 20, horizontalPadding, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Recent Tasks", style: AppTextStyles.subHeading),
                      TextButton.icon(
                        onPressed: () => showSortBottomSheet(context, provider),
                        icon: const Icon(Icons.sort,
                            size: 16, color: AppColors.primary),
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
              ),

              // ---------- TASK LIST ----------
              if (provider.isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else if (provider.tasks.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text("No tasks found", style: AppTextStyles.body),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 0, horizontalPadding, 100),
                  sliver: SliverList.builder(
                    itemCount: provider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = provider.tasks[index];
                      return TaskCard(
                        task: task,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailScreen(taskId: task.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
}