import 'package:bloc/bloc.dart';
import 'package:blutut_clasic/core/services/shared_preferences_service.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecase/user_fetchdata_usecase.dart';
import '../../../domain/usecase/user_login_usecase.dart';
import '../../../injection.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLoginUsecase _userLoginUsecase;
  final UserFetchdataUsecase _userFetchdataUsecase;

  AuthBloc({required UserLoginUsecase userLoginUsecase, required UserFetchdataUsecase userFetchdataUsecase}) :
        _userLoginUsecase = userLoginUsecase,
        _userFetchdataUsecase = userFetchdataUsecase,
        super(AuthInitial()) {

    on<Login>((event, emit) async {
      emit(AuthLoading());
      try {
        await _userLoginUsecase.call(event.username, event.password);
        emit(AuthLoaded(null));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<FetchUserInfo>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = serviceLocator<SharedPreferencesService>().getToken();
        if (token == null) {
          emit(AuthError("No token available"));
          return;
        }
        final response = await _userFetchdataUsecase.call(token);
        emit(AuthLoaded(response));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
