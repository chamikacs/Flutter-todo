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
import 'package:todo_app/text_styles.dart';

enum TodoFilter { all, time, deadline }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoFilter selectedFilter = TodoFilter.all;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TodoBloc>(context).add(LoadTodos(selectedFilter.name));
  }

  Future<void> _refreshTodos() async {
    BlocProvider.of<TodoBloc>(context).add(LoadTodos(selectedFilter.name));
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
            child: Text(
              'TO DO LIST',
              style: AppTextStyles.headline2(AppColors.peach),
            ),
          ),
          actions: [
            IconButton(
              icon: Image.asset('assets/settings.png'),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/Union.png',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'LIST OF TODO',
                            style: AppTextStyles.headline1,
                          ),
                        ],
                      ),
                      PopupMenuButton<TodoFilter>(
                        icon: Image.asset('assets/filter.png'), // Filter icon
                        onSelected: (TodoFilter filter) {
                          setState(() {
                            selectedFilter = filter;
                          });
                          BlocProvider.of<TodoBloc>(context)
                              .add(LoadTodos(selectedFilter.name));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<TodoFilter>>[
                          PopupMenuItem<TodoFilter>(
                            value: TodoFilter.all,
                            child: Text(
                              'All',
                              style: selectedFilter == TodoFilter.all
                                  ? AppTextStyles.headline7(AppColors.coral)
                                  : AppTextStyles.headline7(Colors.black),
                            ),
                          ),
                          PopupMenuItem<TodoFilter>(
                            value: TodoFilter.time,
                            child: Text(
                              'By Time',
                              style: selectedFilter == TodoFilter.time
                                  ? AppTextStyles.headline7(AppColors.coral)
                                  : AppTextStyles.headline7(Colors.black),
                            ),
                          ),
                          PopupMenuItem<TodoFilter>(
                            value: TodoFilter.deadline,
                            child: Text(
                              'By Deadline',
                              style: selectedFilter == TodoFilter.deadline
                                  ? AppTextStyles.headline7(AppColors.coral)
                                  : AppTextStyles.headline7(Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, state) {
                        if (state is TodoLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is TodoLoaded) {
                          final todos = state.todos;

                          if (todos.isEmpty) {
                            return const Center(
                              child: Text(
                                'No Todos Available',
                                style: TextStyle(color: AppColors.black),
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: _refreshTodos,
                            child: ListView.builder(
                              itemCount: todos.length,
                              itemBuilder: (context, index) {
                                final todo = todos[index];
                                return TodoCard(
                                  todo: todo,
                                  filterOption: selectedFilter.name,
                                  todoBloc: BlocProvider.of<TodoBloc>(context),
                                );
                              },
                            ),
                          );
                        } else if (state is TodoError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Failed to load todos',
                                  style: TextStyle(color: AppColors.black),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    _refreshTodos();
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
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
              isScrollControlled: true,
              builder: (context) => const AddTodoBottomSheet(),
            );
          },
          child: Material(
            elevation: 40,
            shape: const CircleBorder(),
            color: Colors.transparent,
            child: SizedBox(
              height: 92,
              width: 92,
              child: Image.asset(
                'assets/plus-circle.png',
                height: 92,
                width: 92,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
