import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com/todos';

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?limit=30'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> todos = data['todos'];
        return todos.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}