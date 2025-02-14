import 'package:bloc/bloc.dart';

import '../../../core/services/shared_preferences_service.dart';
import '../../../domain/entities/login_request_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SharedPreferencesService _sharedPreferencesService;
  final AuthUsecase _authUsecase;

  AuthCubit(this._sharedPreferencesService, this._authUsecase) : super(AuthInitial());

  Future<void> storeCookie(String cookie) async {
    emit(AuthLoading());
    await _sharedPreferencesService.setString('cookie', cookie);
    emit(AuthStored());
  }

  void loadCookie() {
    emit(AuthLoading());
    final cookie = _sharedPreferencesService.getString('cookie');
    if (cookie != null) {
      emit(AuthLoaded(cookie));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> login(LoginRequestEntity loginRequest) async {
    emit(AuthLoading());
    try {
      final cookie = await _authUsecase.login(loginRequest);
      if (cookie != null) {
        await storeCookie(cookie);
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authUsecase.logout();
      await _sharedPreferencesService.clearCookie();
      emit(AuthInitial()); // Go back to initial state after logout
    } catch (e) {
      emit(AuthError(message: e.toString())); // Handle logout errors
    }
  }
}