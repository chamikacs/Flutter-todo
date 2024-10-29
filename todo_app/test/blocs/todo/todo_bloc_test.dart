import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/blocs/todo/todo_event.dart';
import 'package:todo_app/blocs/todo/todo_state.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/repositories/todo_repository.dart';

import '../../mocks/mock_services.mocks.dart';

void main() {
  late TodoBloc todoBloc;
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    todoBloc = TodoBloc(mockTodoRepository);
  });

  final Todo mockTodo = Todo(
    id: '1',
    title: 'Test Todo',
    description: 'This is a test todo',
    deadline: DateTime.now(),
  );

  group('TodoBloc', () {
    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] when LoadTodos is added',
      build: () {
        when(mockTodoRepository.fetchTodos())
            .thenAnswer((_) async => [mockTodo]);
        return todoBloc;
      },
      act: (bloc) => bloc.add(LoadTodos()),
      expect: () => [
        TodoLoading(),
        TodoLoaded([mockTodo])
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] when AddTodo is added',
      build: () {
        when(mockTodoRepository.addTodo(mockTodo)).thenAnswer((_) async => {});
        when(mockTodoRepository.fetchTodos())
            .thenAnswer((_) async => [mockTodo]);
        return todoBloc;
      },
      act: (bloc) => bloc.add(AddTodo(mockTodo)),
      expect: () => [
        TodoLoading(),
        TodoLoaded([mockTodo])
      ],
    );

    // blocTest<TodoBloc, TodoState>(
    //   'emits [TodoLoading, TodoLoaded] when EditTodo is added',
    //   build: () {
    //     when(mockTodoRepository.editTodo(mockTodo))
    //         .thenAnswer((_) async => mockTodo);
    //     when(mockTodoRepository.fetchTodos())
    //         .thenAnswer((_) async => [mockTodo]);
    //     return todoBloc;
    //   },
    //   act: (bloc) => bloc.add(EditTodoRequested(mockTodo)),
    //   expect: () => [
    //     TodoLoading(),
    //     TodoLoaded([mockTodo])
    //   ],
    // );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] when DeleteTodo is added',
      build: () {
        when(mockTodoRepository.deleteTodoById(mockTodo.id))
            .thenAnswer((_) async => {});
        when(mockTodoRepository.fetchTodos()).thenAnswer((_) async => []);
        return todoBloc;
      },
      act: (bloc) => bloc.add(DeleteTodo(mockTodo.id)),
      expect: () => [TodoLoading(), TodoLoaded([])],
    );
  });

  blocTest<TodoBloc, TodoState>(
    'emits [EditTodoLoading, EditTodoSuccess, TodoLoading, TodoLoaded] when EditTodo is added',
    build: () {
      when(mockTodoRepository.editTodo(mockTodo))
          .thenAnswer((_) async => mockTodo);
      when(mockTodoRepository.fetchTodos()).thenAnswer((_) async => [mockTodo]);
      return todoBloc;
    },
    act: (bloc) => bloc.add(EditTodoRequested(mockTodo)),
    expect: () => [
      EditTodoLoading(),
      EditTodoSuccess(mockTodo),
      TodoLoading(),
      TodoLoaded([mockTodo]),
    ],
  );
}
