// blocs/auth/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:todo_app/blocs/todo/todo_event.dart';
import 'package:todo_app/repositories/auth_repository.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart'; // Import TodoBloc for access
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final TodoBloc todoBloc;

  AuthBloc(this.authRepository, this.todoBloc) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await authRepository.login(event.email, event.password);
        emit(AuthAuthenticated(token));

        // Save login status
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Load todos after successful login
        todoBloc.add(LoadTodos());
      } catch (e) {
        emit(AuthError("Login failed: ${e.toString()}"));
      }
    });

    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signup(event.name, event.email, event.password);
        emit(AuthSignedUp());
      } catch (e) {
        emit(AuthError("Signup failed: ${e.toString()}"));
      }
    });

    on<FetchUserProfile>((event, emit) async {
      emit(AuthLoading());
      try {
        final profileData = await authRepository.fetchUserProfile(event.userId);
        emit(UserProfileLoaded(profileData));
      } catch (e) {
        emit(AuthError("Failed to load profile: ${e.toString()}"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        await authRepository.logout();
        // Clear login status
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // Clears all user-specific data

        emit(AuthUnauthenticated());

        // Clear todos when logging out
        todoBloc.add(ClearTodosEvent());
      } catch (e) {
        emit(AuthError("Failed to load profile: ${e.toString()}"));
      }
    });

    on<ChangePasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.changePassword(event.userId, event.password);
        emit(ChangePasswordSuccess("Password changed successfully"));
      } catch (e) {
        emit(ChangePasswordError(e.toString()));
      }
    });
  }
}
