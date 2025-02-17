import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UserFetchUseCase {

  UserFetchUseCase(this._userRepository);
  final UserRepository _userRepository;

  Future<UserEntity> call() async => _userRepository.getUserInfo();
}
