// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/todo.dart';

class ApiService {
  final String baseUrl = 'http://localhost:5555/api';

  // Helper method to get the JWT token from shared preferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Helper method to set the headers with Authorization if token is available
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Login method
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Successfully logged in, parse the token and return
      final data = jsonDecode(response.body);
      return data; // Return any additional data you might need
    } else {
      // Return detailed error information
      final errorMessage =
          jsonDecode(response.body)['message'] ?? 'Failed to login';
      throw Exception(errorMessage);
    }
  }

  // Signup method
  Future<void> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      // Successfully signed up, parse the token and return
      jsonDecode(response.body);
      // return data; // Return any additional data you might need
    } else {
      // Return detailed error information
      final errorMessage =
          jsonDecode(response.body)['message'] ?? 'Failed to login';
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/auth/$userId'), // Adjust endpoint as needed
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  // Logout by removing the token
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
  }

  // Fetch todos
  Future<List<Todo>> fetchTodos() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/todos'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // print("Todo response : ${response.body}");
      // Decode the JSON response
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((todo) => Todo.fromJson(todo))
          .toList(); // Assuming Todo has a fromJson method
    } else {
      throw Exception(
          'Failed to fetch todos with status: ${response.statusCode}');
    }
  }

  // Add a new todo
  Future<void> addTodo(Todo todo) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: headers,
      body: jsonEncode({
        'title': todo.title,
        'description': todo.description,
        'deadline': todo.deadline?.toIso8601String(),
        'image': todo.image
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add todo');
    }
  }

  // Delete a todo by ID
  Future<void> deleteTodoById(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/todos/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    } else {
      print("Deleted successfully");
    }
  }

  // Edit a todo by ID
  Future<Todo> editTodo(Todo todo) async {
    final headers = await _getHeaders();
    print(todo.id);
    final response = await http.put(Uri.parse('$baseUrl/todos/${todo.id}'),
        headers: headers,
        body: jsonEncode({
          'title': todo.title,
          'description': todo.description,
          'deadline': todo.deadline?.toIso8601String(),
          'image': todo.image
        }));
    print(response.body);
    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to edit the todo');
    }
  }
}
