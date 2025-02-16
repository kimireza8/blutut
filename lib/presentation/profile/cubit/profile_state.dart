part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {

  ProfileLoaded({required this.user});
  final UserEntity user;
}

final class ProfileError extends ProfileState {

  ProfileError({required this.message});
  final String message;
}
