import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/components/bottom_sheet.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/blocs/todo/todo_event.dart';
import 'package:todo_app/blocs/todo/todo_state.dart';
import 'package:intl/intl.dart';

class DetailTodoScreen extends StatelessWidget {
  final String? todoId;

  DetailTodoScreen({required this.todoId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TodoLoaded) {
          final todo = state.todos.any((t) => t.id == todoId)
              ? state.todos.firstWhere((t) => t.id == todoId)
              : null;

          if (todo == null) {
            return const Center(child: Text("Todo not found."));
          }

          Uint8List? imageBytes;
          if (todo.image != null && todo.image!.isNotEmpty) {
            imageBytes = base64Decode(todo.image!);
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Image.asset('lib/assets/edit-2.png'),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => AddTodoBottomSheet(todo: todo),
                    );
                  },
                ),
                IconButton(
                  icon: Image.asset('lib/assets/trash-2.png'),
                  onPressed: () => _showDeleteConfirmation(context, todo.id),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize
                      .min, // Allows the column to take up only needed space
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      todo.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.black.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Display image if available, otherwise show placeholder
                    if (todo.image != null && todo.image!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.memory(
                          imageBytes!,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[500],
                          size: 50,
                        ),
                      ),

                    const SizedBox(height: 30),

                    Center(
                      child: Text(
                        'Created at ${_formatDate(todo.createdAt)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.black.withOpacity(0.6),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        } else if (state is TodoError) {
          return Center(child: Text(state.error));
        }
        return Container();
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String? todoId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () {
              if (todoId != null) {
                context.read<TodoBloc>().add(DeleteTodo(todoId));
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to the previous screen
              }
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('dd MMMM yyyy').format(date) : 'N/A';
  }
}
