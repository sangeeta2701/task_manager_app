import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

// Custom exception for API errors with a user-friendly msg
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  static const String baseUrl = 'https://dummyjson.com/todos';
  static const Duration _timeout = Duration(seconds: 15);

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl?limit=30'))
          .timeout(_timeout);

      //Handle HTTP status codes ----
      if (response.statusCode == 200) {
        return _parseTasks(response.body);
      } else if (response.statusCode == 404) {
        throw ApiException(
          "The task service is currently unavailable. Please try again later.",
          statusCode: 404,
        );
      } else if (response.statusCode == 500) {
        throw ApiException(
          "Something went wrong on our end. Please try again in a moment.",
          statusCode: 500,
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw ApiException(
          "You don't have permission to access this resource.",
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException(
          "Unexpected error (${response.statusCode}). Please try again.",
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      //No internet / DNS failure ----
      throw ApiException(
        "No internet connection. Please check your network and try again.",
      );
    } on TimeoutException {
      //Request timed out-----
      throw ApiException(
        "The request took too long. Please check your connection and retry.",
      );
    } on FormatException {
      // JSON parsing failure ----
      throw ApiException(
        "Received invalid data from the server. Please try again.",
      );
    } on ApiException {
      // rethrow the previous API exceptions----
      rethrow;
    } catch (e) {
      //for unexpected errors ----
      throw ApiException(
        "Something unexpected happened. Please try again.",
      );
    }
  }

  //Separated parsing logic for clarity
  List<Task> _parseTasks(String body) {
    try {
      final data = json.decode(body);
      final List<dynamic> todos = data['todos'];
      return todos.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw ApiException(
        "Unable to read the task data. Please try again.",
      );
    }
  }
}