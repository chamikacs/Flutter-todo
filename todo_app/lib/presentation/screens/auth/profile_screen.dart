import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/presentation/screens/auth/sign_in_screen.dart';
import 'package:todo_app/blocs/auth/auth_bloc.dart';
import 'package:todo_app/blocs/auth/auth_event.dart';
import 'package:todo_app/blocs/auth/auth_state.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/blocs/todo/todo_event.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<String?> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen
            },
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: _loadUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != null) {
            context.read<AuthBloc>().add(FetchUserProfile(snapshot.data!));
          } else {
            return const Center(child: Text('User ID not found'));
          }

          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserProfileLoaded) {
                  final profile = state.userProfile;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.asset(
                              'lib/assets/rafiki.png',
                              height: 250,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileInfoRow(
                                label: 'Full Name',
                                value: profile['name'] ?? 'N/A'),
                            const SizedBox(height: 16),
                            ProfileInfoRow(
                                label: 'Email',
                                value: profile['email'] ?? 'N/A'),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Text(
                                  'Password',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    // Placeholder for changing the password
                                  },
                                  child: const Text(
                                    'Change Password',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrangeAccent,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                context.read<AuthBloc>().add(LogoutRequested());
                                context.read<TodoBloc>().add(ClearTodosEvent());
                              },
                              child: const Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                } else if (state is AuthError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('No Profile Data'));
              },
            ),
          );
        },
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.deepOrangeAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
