import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/presentation/screens/auth/change_password.dart';
import 'package:todo_app/presentation/screens/auth/sign_in_screen.dart';
import 'package:todo_app/blocs/auth/auth_bloc.dart';
import 'package:todo_app/blocs/auth/auth_event.dart';
import 'package:todo_app/blocs/auth/auth_state.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/blocs/todo/todo_event.dart';
import 'package:todo_app/text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<String?> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
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
                              'assets/rafiki.png',
                              height: 250,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Full Name",
                                  style: AppTextStyles.body1(Colors.grey),
                                ),
                                const Spacer(),
                                Text(
                                  profile['name'] ?? 'N/A',
                                  style:
                                      AppTextStyles.headline3(AppColors.peach),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  "Full Name",
                                  style: AppTextStyles.body1(Colors.grey),
                                ),
                                const Spacer(),
                                Text(
                                  profile['email'] ?? 'N/A',
                                  style: AppTextStyles.body1(AppColors.peach),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  'Password',
                                  style: AppTextStyles.body1(AppColors.peach),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () async {
                                    String? userId = await _loadUserId();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangePasswordScreen(
                                                userID: userId,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    'Change Password',
                                    style: AppTextStyles.body1(AppColors.coral),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.peach,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                context.read<AuthBloc>().add(LogoutRequested());
                                context.read<TodoBloc>().add(ClearTodosEvent());
                              },
                              child: Text(
                                'Log Out',
                                style: AppTextStyles.button(Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('No Profile Data'));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
