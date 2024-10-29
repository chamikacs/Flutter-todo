import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/blocs/todo/todo_event.dart';
import 'package:todo_app/models/todo.dart';

class AddTodoScreen extends StatefulWidget {
  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTodo = Todo(
                title: titleController.text,
                description: descriptionController.text,
                deadline: DateTime.now(),
              );
              BlocProvider.of<TodoBloc>(context)
                  .add(AddTodo(newTodo)); // Adding the todo
              Navigator.pop(context); // Close the modal after adding
            },
            child: Text('Add Todo'),
          ),
        ],
      ),
    );
  }
}
