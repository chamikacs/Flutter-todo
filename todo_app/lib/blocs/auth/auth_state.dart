import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignedUp extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  AuthAuthenticated(this.token);

  @override
  List<Object?> get props => [token];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// State for when the user profile data is loaded
class UserProfileLoaded extends AuthState {
  final Map<String, dynamic> userProfile;

  UserProfileLoaded(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class ChangePasswordSuccess extends AuthState {
  final String message;

  ChangePasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ChangePasswordError extends AuthState {
  final String error;

  ChangePasswordError(this.error);

  @override
  List<Object?> get props => [error];
}
