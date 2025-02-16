part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthStored extends AuthState {}

class AuthLoaded extends AuthState {
  AuthLoaded(this.cookie);
  final String cookie;
}

class AuthError extends AuthState {
  AuthError({required this.message});
  final String message;
}
