import 'package:bloc/bloc.dart';

import '../../../core/services/shared_preferences_service.dart';
import '../../../domain/entities/login_request_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._sharedPreferencesService, this._authUsecase)
      : super(AuthInitial());
  final SharedPreferencesService _sharedPreferencesService;
  final AuthUsecase _authUsecase;

  Future<void> storeCookie(String cookie) async {
    emit(AuthLoading());
    await _sharedPreferencesService.setString('cookie', cookie);
    emit(AuthStored());
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
      String cookie = await _authUsecase.login(loginRequest);
      await storeCookie(cookie);
    } catch (e) {
      emit(AuthError(message: 'Login failed'));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authUsecase.logout();
      await _sharedPreferencesService.clearCookie();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
