import 'package:flutter/material.dart';
import '../data/models/task_model.dart';
import '../data/services/api_service.dart';

enum SortOption { priority, dueDate, status }

class TaskProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Task> _allTasks = [];
  
  List<Task> _filteredTasks = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';
  String _filterStatus = 'All';
  SortOption _sortOption = SortOption.dueDate;

  // Getters
  List<Task> get tasks => _filteredTasks;
  List<Task> get allTasks => _allTasks;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get filterStatus => _filterStatus;
  SortOption get sortOption => _sortOption;
  
  // Stats
  int get totalTasks => _allTasks.length;
  int get completedTasks => _allTasks.where((t) => t.status == 'Completed').length;
  int get pendingTasks => _allTasks.where((t) => t.status == 'Not Started').length;
  int get inProgressTasks => _allTasks.where((t) => t.status == 'In Progress').length;

  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _allTasks = await _apiService.fetchTasks();
      _applyFiltersAndSort();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchTasks(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    _applyFiltersAndSort();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    _applyFiltersAndSort();
  }

  // NEW: Method to add a task manually
  void addTask(Task task) {
    _allTasks.insert(0, task); // Add to top of list
    _applyFiltersAndSort();
  }

  // NEW: Method to delete a task
  void deleteTask(int taskId) {
    _allTasks.removeWhere((t) => t.id == taskId);
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    // 1. Filter by Search
    List<Task> temp = _allTasks.where((task) => 
      task.title.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    // 2. Filter by Status
    if (_filterStatus != 'All') {
      temp = temp.where((task) => task.status == _filterStatus).toList();
    }

    // 3. Sort Logic (Fixed)
    if (temp.isNotEmpty) {
      switch (_sortOption) {
        case SortOption.priority:
          // High -> Medium -> Low
          temp.sort((a, b) => _getPriorityValue(b.priority).compareTo(_getPriorityValue(a.priority)));
          break;
        case SortOption.dueDate:
          // Earliest date first
          temp.sort((a, b) => a.dueDate.compareTo(b.dueDate));
          break;
        case SortOption.status:
          // Alphabetical or custom order
          temp.sort((a, b) => a.status.compareTo(b.status));
          break;
      }
    }

    _filteredTasks = temp;
    notifyListeners();
  }

  int _getPriorityValue(String priority) {
    if (priority == 'High') return 3;
    if (priority == 'Medium') return 2;
    if (priority == 'Low') return 1;
    return 0;
  }

  void updateTaskStatus(int taskId, String newStatus) {
    final index = _allTasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      String newAssignee = 'You';
      if (newStatus == 'Discussion Required') newAssignee = 'Manager';
      if (newStatus == 'Shared for Testing') newAssignee = 'QA Team';
      if (newStatus == 'Completed') newAssignee = 'None';

      _allTasks[index] = _allTasks[index].copyWith(status: newStatus, assignedTo: newAssignee);
      _applyFiltersAndSort();
    }
  }
}