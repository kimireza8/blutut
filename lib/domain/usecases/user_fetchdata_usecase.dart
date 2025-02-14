import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UserFetchDataUsecase {
  final UserRepository _userRepository;

  UserFetchDataUsecase(this._userRepository);

  Future<UserEntity> call() async {
    return await _userRepository.getUserInfo();
  }
}