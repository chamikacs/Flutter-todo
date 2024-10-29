// screens/auth/auth_check.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/blocs/todo/todo_event.dart';
import 'package:todo_app/presentation/screens/auth/sign_in_screen.dart';
import 'package:todo_app/presentation/screens/todo/home_screen.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _checkIfUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data == true) {
            context.read<TodoBloc>().add(LoadTodos());
            return const HomeScreen();
          } else {
            return SignInScreen();
          }
        });
  }

  Future<bool> _checkIfUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
