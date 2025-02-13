import 'package:blutut_clasic/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> login(String username, String password) async {
    // TODO: implement login
    return await 'Auth';
  }
}