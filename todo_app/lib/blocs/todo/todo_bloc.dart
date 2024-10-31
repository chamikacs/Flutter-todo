// blocs/todo/todo_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:todo_app/blocs/todo/todo_event.dart';
import 'package:todo_app/blocs/todo/todo_state.dart';
import 'package:todo_app/repositories/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;
  String currentFilter = 'all';

  TodoBloc(this.todoRepository) : super(TodoLoading()) {
    on<LoadTodos>((event, emit) async {
      emit(TodoLoading());
      try {
        currentFilter = event.filter;
        final todos = await todoRepository.fetchTodos(currentFilter);
        emit(TodoLoaded(todos));
      } catch (error) {
        emit(TodoError('Failed to load todos: $error'));
      }
    });

    on<AddTodo>((event, emit) async {
      try {
        await todoRepository.addTodo(event.todo, imageFile: event.imageFile);
        add(LoadTodos());
      } catch (e) {
        print(e);
        emit(TodoError(e.toString()));
      }
    });

    on<DeleteTodo>((event, emit) async {
      await todoRepository.deleteTodoById(event.id!);
      add(LoadTodos()); // Reload todos after deletion
    });

    on<EditTodoRequested>((event, emit) async {
      emit(EditTodoLoading());
      try {
        final updatedTodo = await todoRepository.editTodo(event.updatedTodo,
            imageFile: event.imageFile);
        emit(EditTodoSuccess(updatedTodo));
        add(LoadTodos());
      } catch (e) {
        emit(EditTodoError("Failed to edit todo: ${e.toString()}"));
      }
    });

    on<ClearTodosEvent>((event, emit) {
      emit(TodoLoaded([])); // Emit an empty todo list to clear the display
    });
  }
}
