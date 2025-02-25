import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/constants/constant.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../../domain/entities/auth/login_request_entity.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit._({
    required SharedPreferencesService sharedPreferencesService,
    required LoginUsecase loginUsecase,
    required LogoutUsecase logoutUsecase,
  })  : _sharedPreferencesService = sharedPreferencesService,
        _loginUsecase = loginUsecase,
        _logoutUsecase = logoutUsecase,
        super(AuthInitial());

  factory AuthCubit.create() => AuthCubit._(
      sharedPreferencesService: serviceLocator<SharedPreferencesService>(),
      loginUsecase: serviceLocator<LoginUsecase>(),
      logoutUsecase: serviceLocator<LogoutUsecase>(),
    );

  final SharedPreferencesService _sharedPreferencesService;
  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;

  Future<void> login(LoginRequestEntity loginRequest) async {
    emit(AuthLoading());
    try {
      String cookie = await _loginUsecase.call(loginRequest);
      await _sharedPreferencesService.setString(Constant.cookieKey, cookie);
      emit(AuthLoaded(cookie));
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

  void loadCookie() {
    String? cookie = _sharedPreferencesService.getString(Constant.cookieKey);
    if (cookie != null) {
      emit(AuthLoaded(cookie));
    } else {
      emit(AuthInitial());
    }
  }
}
