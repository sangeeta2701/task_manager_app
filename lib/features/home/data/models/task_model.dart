
class Task {
  final int id;
  final String title;
  final String description;
  final String priority;
  String status;
  String assignedTo;
  final String assignedBy;
  final DateTime dueDate;
  final String category;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.assignedTo,
    required this.assignedBy,
    required this.dueDate,
    required this.category,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['todo'],
      description: "This is a detailed description for task ${json['id']}. Please complete it before the deadline.",
      priority: _getPriority(json['id']),
      status: json['completed'] ? 'Completed' : 'Not Started',
      assignedTo: 'You',
      assignedBy: 'Manager',
      dueDate: DateTime.now().add(Duration(days: json['id'] % 7)),
      category: 'Development',
    );
  }

  static String _getPriority(int id) {
    if (id % 3 == 0) return 'High';
    if (id % 3 == 1) return 'Medium';
    return 'Low';
  }

  Task copyWith({String? status, String? assignedTo}) {
    return Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedBy: assignedBy,
      dueDate: dueDate,
      category: category,
    );
  }
}