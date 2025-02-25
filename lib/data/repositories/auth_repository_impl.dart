import '../../domain/repositories/auth_repository.dart';
import '../models/auth/login_request_model.dart';
import '../remote/auth/remote_auth_provider.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required RemoteAuthProvider remoteAuthProvider})
      : _remoteAuthProvider = remoteAuthProvider;
  final RemoteAuthProvider _remoteAuthProvider;

  @override
  Future<String> login(LoginRequest loginRequest) async {
    Future<String> cookie = _remoteAuthProvider.login(loginRequest);
    return cookie;
  }

  @override
  Future<void> logout() async => _remoteAuthProvider.logout();
}
