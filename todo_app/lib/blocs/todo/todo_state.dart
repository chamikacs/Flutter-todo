// blocs/todo/todo_state.dart
import 'package:equatable/equatable.dart';
import 'package:todo_app/models/todo.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  TodoLoaded(this.todos);

  @override
  List<Object> get props => [todos];
}

class TodoError extends TodoState {
  final String error;
  TodoError(this.error);

  @override
  List<Object> get props => [error];
}

class EditTodoLoading extends TodoState {}

class TodosCleared extends TodoState {}

class EditTodoSuccess extends TodoState {
  final Todo updatedTodo;
  EditTodoSuccess(this.updatedTodo);

  @override
  List<Object> get props => [updatedTodo];
}

class EditTodoError extends TodoState {
  final String error;
  EditTodoError(this.error);

  @override
  List<Object> get props => [error];
}
