import 'package:bloc/bloc.dart';
import 'package:blutut_clasic/core/services/shared_preferences_service.dart';
import 'package:blutut_clasic/domain/entities/login_request_entity.dart';
import 'package:blutut_clasic/domain/usecases/auth_usecases.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SharedPreferencesService _sharedPreferencesService;
  final LoginUsecase _loginUsecase;

  AuthCubit(this._sharedPreferencesService, this._loginUsecase) : super(AuthInitial());

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
      final cookie = await _loginUsecase.call(loginRequest);
      if (cookie != null) {
        await storeCookie(cookie);
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }
}