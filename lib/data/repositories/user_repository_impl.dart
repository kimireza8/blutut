import 'package:blutut_clasic/data/remote/remote_auth_provider.dart';

import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteAuthProvider _remoteAuthProvider;

  UserRepositoryImpl({required RemoteAuthProvider remoteAuthProvider})
      : _remoteAuthProvider = remoteAuthProvider;

  @override
  Future<void> login(String username, String password) async {
    await _remoteAuthProvider.login(username, password);
  }

  @override
  Future<Map<String, dynamic>?> fetchUserInfo(String token) async {
    final response = await _remoteAuthProvider.fetchUserInfo(token);
    return response;
  }
}