import 'package:blutut_clasic/domain/repositories/user_repository.dart';

class UserLoginUsecase {
  final UserRepository _userRepository;

  UserLoginUsecase({required UserRepository userRepository}) : _userRepository = userRepository;

  Future<void> call(String username, String password) async {
    await _userRepository.login(username, password);
  }

}