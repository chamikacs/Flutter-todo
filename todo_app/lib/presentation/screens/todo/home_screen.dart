import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/components/bottom_sheet.dart';
import 'package:todo_app/presentation/components/todo_card.dart';
import 'package:todo_app/presentation/screens/auth/profile_screen.dart';
import 'package:todo_app/presentation/screens/auth/sign_in_screen.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/blocs/auth/auth_bloc.dart';
import 'package:todo_app/blocs/auth/auth_state.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/blocs/todo/todo_event.dart';
import 'package:todo_app/blocs/todo/todo_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TodoBloc>(context).add(LoadTodos());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.white,
          elevation: 0,
          title: Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'TO DO LIST',
              style: TextStyle(
                color: AppColors.peach,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Image.asset(
                  'lib/assets/settings.png'), // Placeholder for settings icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Distributes space
                    children: [
                      Row(
                        // Wrap the first two items in another Row
                        children: [
                          Image.asset(
                            'lib/assets/Union.png', // Replace with your icon path
                            height: 30, // Set the desired height
                            width: 30, // Set the desired width
                          ),
                          SizedBox(width: 10),
                          const Text(
                            'LIST OF TODO',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.coral,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Image.asset(
                            'lib/assets/filter.png'), // Placeholder for filter icon
                        onPressed: () {
                          // Handle filter button press
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, state) {
                        if (state is TodoLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is TodoLoaded) {
                          final todos = state.todos;

                          if (todos.isEmpty) {
                            return Center(
                              child: Text(
                                'No Todos Available',
                                style: TextStyle(color: AppColors.black),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              final todo = todos[index];
                              return TodoCard(todo: todo);
                            },
                          );
                        } else if (state is TodoError) {
                          return Center(
                            child: Text(
                              'Failed to load todos',
                              style: TextStyle(color: AppColors.black),
                            ),
                          );
                        }

                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled:
                  true, // Allows the bottom sheet to take up more space
              builder: (context) => AddTodoBottomSheet(),
            );
          },
          child: SizedBox(
            height: 92,
            width: 92,
            child: Image.asset(
              'lib/assets/plus-circle.png',
              height: 92, // Adjust the size as needed
              width: 92,
            ),
          ),
        ),
      ),
    );
  }
}
