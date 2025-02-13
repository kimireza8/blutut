part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthStored extends AuthState {}

class AuthLoaded extends AuthState {
  final String cookie;

  AuthLoaded(this.cookie);
}