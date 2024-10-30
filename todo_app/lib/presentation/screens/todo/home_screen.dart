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
    // Load todos when the HomeScreen is initialized
    BlocProvider.of<TodoBloc>(context).add(LoadTodos(selectedFilter.name));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<TodoBloc>(context).add(LoadTodos(selectedFilter.name));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Navigate to SignInScreen if the user is unauthenticated
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
          automaticallyImplyLeading: false, // Do not show the back button
          backgroundColor: AppColors.white,
          elevation: 0, // Remove shadow from the AppBar
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
              icon: Image.asset('lib/assets/settings.png'), // Settings icon
              onPressed: () {
                // Navigate to the ProfileScreen on press
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
              padding:
                  const EdgeInsets.all(16.0), // Add padding around the content
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align items to the start
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Distribute space evenly
                    children: [
                      Row(
                        // Wrap the first two items in another Row for alignment
                        children: [
                          Image.asset(
                            'lib/assets/Union.png', // Icon for the list
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(
                              width: 10), // Space between icon and text
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
                      PopupMenuButton<TodoFilter>(
                        icon:
                            Image.asset('lib/assets/filter.png'), // Filter icon
                        onSelected: (TodoFilter filter) {
                          setState(() {
                            selectedFilter = filter; // Update selected filter
                          });
                          // Optionally, you can trigger a filter action here
                          BlocProvider.of<TodoBloc>(context)
                              .add(LoadTodos(selectedFilter.name));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                        color: Colors.white,
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<TodoFilter>>[
                          PopupMenuItem<TodoFilter>(
                            value: TodoFilter.all,
                            child: Text(
                              'All',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedFilter == TodoFilter.all
                                    ? Colors.orange
                                    : null,
                              ),
                            ),
                          ),
                          PopupMenuItem<TodoFilter>(
                            value: TodoFilter.time,
                            child: Text(
                              'By Time',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedFilter == TodoFilter.time
                                    ? Colors.orange
                                    : null,
                              ),
                            ),
                          ),
                          PopupMenuItem<TodoFilter>(
                            value: TodoFilter.deadline,
                            child: Text(
                              'By Deadline',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedFilter == TodoFilter.deadline
                                    ? Colors.orange
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Space between title and list

                  Expanded(
                    child: BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, state) {
                        if (state is TodoLoading) {
                          // Show loading indicator while fetching todos
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is TodoLoaded) {
                          final todos = state.todos; // Get the list of todos

                          if (todos.isEmpty) {
                            // Show message if no todos are available
                            return const Center(
                              child: Text(
                                'No Todos Available',
                                style: TextStyle(color: AppColors.black),
                              ),
                            );
                          }

                          // Display list of todos
                          return ListView.builder(
                            itemCount: todos.length, // Set the number of items
                            itemBuilder: (context, index) {
                              final todo =
                                  todos[index]; // Get todo at current index
                              return TodoCard(
                                todo: todo,
                                filterOption: selectedFilter.name,
                                todoBloc: BlocProvider.of<TodoBloc>(context),
                              ); // Display each todo item
                            },
                          );
                        } else if (state is TodoError) {
                          // Show error message if fetching todos fails
                          return const Center(
                            child: Text(
                              'Failed to load todos',
                              style: TextStyle(color: AppColors.black),
                            ),
                          );
                        }

                        return Container(); // Return empty container if no state matched
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
            // Show bottom sheet to add a new todo on button tap
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
                'lib/assets/plus-circle.png', // Plus icon for adding todo
                height: 92, // Adjust the size as needed
                width: 92,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
