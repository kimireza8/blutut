import '../../../data/models/auth/login_request_model.dart';
import '../../entities/auth/login_request_entity.dart';
import '../../repositories/auth_repository.dart';

class LoginUsecase {
  LoginUsecase(this._authRepository);
  final AuthRepository _authRepository;

  Future<String> call(LoginRequestEntity loginRequest) async {
    String cookie = await _authRepository.login(
      LoginRequest(
        username: loginRequest.username,
        password: loginRequest.password,
        rememberMe: loginRequest.rememberMe,
      ),
    );
    return cookie;
  }
}
