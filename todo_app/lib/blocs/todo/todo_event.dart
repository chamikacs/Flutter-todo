// blocs/todo/todo_event.dart
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:todo_app/models/todo.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {
  final String filter;

  LoadTodos([this.filter = 'all']);

  @override
  List<Object?> get props => [filter];
}

class ClearTodosEvent extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;
  final File? imageFile;

  AddTodo(this.todo, {this.imageFile});
}

class DeleteTodo extends TodoEvent {
  final String? id;
  DeleteTodo(this.id);
}

class EditTodoRequested extends TodoEvent {
  final Todo updatedTodo;
  final File? imageFile;

  EditTodoRequested(this.updatedTodo, {this.imageFile});

  @override
  List<Object> get props => [updatedTodo];
}
