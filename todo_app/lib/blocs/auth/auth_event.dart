// blocs/auth/auth_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted
    extends AuthEvent {} // Checks if user is logged in on app start

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class SignupRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  SignupRequested(this.name, this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

class FetchUserProfile extends AuthEvent {
  final String userId;

  FetchUserProfile(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ChangePasswordRequested extends AuthEvent {
  final String userId;
  final String password;

  ChangePasswordRequested({required this.userId, required this.password});
}
