import 'package:blutut_clasic/data/models/login_request_model.dart';

abstract class AuthRepository {
  Future<String> login(LoginRequest loginRequest);
  Future<void> logout(); // Add logout method
}