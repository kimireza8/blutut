import '../../data/models/auth/login_request_model.dart';

abstract class AuthRepository {
  Future<String> login(LoginRequest loginRequest);
  Future<void> logout();
}
