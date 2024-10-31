import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/screens/auth/auth_check.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/repositories/auth_repository.dart';
import 'package:todo_app/repositories/todo_repository.dart';
import 'package:todo_app/services/api_service.dart';
import 'package:todo_app/blocs/auth/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  final authRepository = AuthRepository(apiService);
  final todoRepository = TodoRepository(apiService);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => TodoBloc(todoRepository)),
      BlocProvider(
        create: (context) =>
            AuthBloc(authRepository, BlocProvider.of<TodoBloc>(context)),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        home: AuthCheck());
  }

  Future<bool> checkIfUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
