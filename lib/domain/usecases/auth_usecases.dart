import '../../data/models/login_request_model.dart';
import '../entities/login_request_entity.dart';
import '../repositories/auth_repository.dart';

class AuthUsecase {
  final AuthRepository _authRepository;

  AuthUsecase(this._authRepository);

  Future<String?> login(LoginRequestEntity loginRequest) async {
    try {
      final cookie = await _authRepository.login(LoginRequest(
        username: loginRequest.username,
        password: loginRequest.password,
        rememberMe: loginRequest.rememberMe,
      ));
      return cookie;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }
}
