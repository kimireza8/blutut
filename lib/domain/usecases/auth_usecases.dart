import '../../data/models/login_request_model.dart';
import '../entities/login_request_entity.dart';
import '../repositories/auth_repository.dart';

class AuthUsecase {
  AuthUsecase(this._authRepository);
  final AuthRepository _authRepository;

  Future<String> login(LoginRequestEntity loginRequest) async {
    String cookie = await _authRepository.login(
      LoginRequest(
        username: loginRequest.username,
        password: loginRequest.password,
        rememberMe: loginRequest.rememberMe,
      ),
    );
    return cookie;
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }
}
