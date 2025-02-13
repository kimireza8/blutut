import 'package:blutut_clasic/data/remote/remote_auth_provider.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthProvider _remoteAuthProvider;

  AuthRepositoryImpl({required RemoteAuthProvider remoteAuthProvider})
      : _remoteAuthProvider = remoteAuthProvider;

  @override
  Future<String> login(LoginRequest loginRequest) async {
    final cookie = _remoteAuthProvider.login(loginRequest);
    return cookie;
  }
}