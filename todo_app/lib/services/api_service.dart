// services/api_service.dart
import 'dart:convert';
import 'dart:io';
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final errorMessage =
          jsonDecode(response.body)['error'] ?? 'Failed to login';
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
    // print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      jsonDecode(response.body);
    } else {
      final errorMessage =
          jsonDecode(response.body)['error'] ?? 'Failed to signup';
      throw Exception(errorMessage);
    }
  }

  //Change password method
  Future<void> changePassword(String userID, String password) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/auth/$userID'),
      headers: headers,
      body: jsonEncode({'newPassword': password}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  // Load user profile mthod
  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/auth/$userId'),
      headers: headers,
    );

    print(response.body);

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

  Future<void> addTodo(Todo todo, {File? imageFile}) async {
    final headers = await _getHeaders();
    final uri = Uri.parse('$baseUrl/todos');
    final Map<String, dynamic> todoData = {
      'title': todo.title,
      'description': todo.description,
      if (todo.deadline != null) 'deadline': todo.deadline!.toIso8601String(),
    };

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      todoData['image'] = base64Encode(bytes); // Encode image to base64
    }

    final response =
        await http.post(uri, headers: headers, body: jsonEncode(todoData));
    // print(response.body);
    if (response.statusCode != 201) {
      throw Exception('Failed to add todo');
    }
  }

  // Edit a todo by ID
  Future<Todo> editTodo(Todo todo, {File? imageFile}) async {
    final headers = await _getHeaders();
    // print(todo.id);
    String? image;
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      image = base64Encode(bytes); // Encode image to base64
    }
    final response = await http.put(Uri.parse('$baseUrl/todos/${todo.id}'),
        headers: headers,
        body: jsonEncode({
          'title': todo.title,
          'description': todo.description,
          'deadline': todo.deadline?.toIso8601String(),
          'image': image
        }));
    // print(response.body);
    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to edit the todo');
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

  // Get all todos
  Future<List<Todo>> fetchTodos(String filter) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse("$baseUrl/todos?filter=$filter"),
        headers: headers);
    if (response.statusCode == 200) {
      // print("Todo response : ${response.body}");
      // Decode the JSON response
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception(
          'Failed to fetch todos with status: ${response.statusCode}');
    }
  }
}
