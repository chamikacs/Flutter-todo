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
                    ).then((_) => context.read<TodoBloc>().add(LoadTodos()));
                  },
                ),
                IconButton(
                  icon: Image.asset('lib/assets/trash-2.png'),
                  onPressed: () => _showDeleteConfirmation(context, todo.id),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (todo.image != null) // Display image if available
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(todo.image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    todo.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black.withOpacity(0.7),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Created at: ${_formatDate(todo.createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.black.withOpacity(0.6),
                    ),
                  ),
                ],
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
