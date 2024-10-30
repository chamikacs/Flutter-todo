import 'dart:io';

import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/api_service.dart';

class TodoRepository {
  final ApiService _apiService;

  TodoRepository(this._apiService);

  // Add a new todo
  Future<void> addTodo(Todo todo, {File? imageFile}) async {
    try {
      await _apiService.addTodo(todo, imageFile: imageFile);
    } catch (e) {
      throw Exception('Error adding todo: $e');
    }
  }

  // Delete a todo by ID
  Future<void> deleteTodoById(String id) async {
    try {
      await _apiService.deleteTodoById(id);
    } catch (e) {
      throw Exception('Error deleting todo: $e');
    }
  }

  Future<Todo> editTodo(Todo updatedTodo, {File? imageFile}) async {
    try {
      return await _apiService.editTodo(updatedTodo, imageFile: imageFile);
    } catch (e) {
      throw Exception('Error adding todo: $e');
    }
  }

  Future<List<Todo>> fetchTodos(String filter) async {
    try {
      return await _apiService.fetchTodos(filter);
    } catch (e) {
      throw Exception('Error adding todo: $e');
    }
  }
}
