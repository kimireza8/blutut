import 'package:blutut_clasic/data/models/login_request_model.dart';
import 'package:blutut_clasic/domain/entities/login_request_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _authRepository;

  LoginUsecase(this._authRepository);

  Future<String?> call(LoginRequestEntity loginRequest) async {
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
}
