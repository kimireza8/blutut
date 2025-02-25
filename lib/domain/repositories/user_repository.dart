import '../entities/user/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUserInfo();
}
