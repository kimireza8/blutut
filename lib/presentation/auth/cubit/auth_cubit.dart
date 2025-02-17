import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../core/services/shared_preferences_service.dart';
import '../../../domain/entities/login_request_entity.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._sharedPreferencesService,
    this._loginUsecase,
    this._logoutUsecase,
  ) : super(AuthInitial());
  final SharedPreferencesService _sharedPreferencesService;
  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;

  Future<void> storeCookie(String cookie) async {
    emit(AuthLoading());
    await _sharedPreferencesService.setString('cookie', cookie);
    emit(AuthLoaded(cookie));
  }

  void loadCookie() {
    emit(AuthLoading());
    String? cookie = _sharedPreferencesService.getString('cookie');
    if (cookie != null) {
      emit(AuthLoaded(cookie));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> login(LoginRequestEntity loginRequest) async {
    emit(AuthLoading());
    try {
      String cookie = await _loginUsecase.call(loginRequest);
      await storeCookie(cookie);
    } catch (e) {
      emit(const AuthError(message: 'Login failed'));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _logoutUsecase.call();
      await _sharedPreferencesService.clearCookie();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
