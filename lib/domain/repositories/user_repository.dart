abstract class UserRepository {
  Future<void> login(String username, String password);
  Future<Map<String, dynamic>?> fetchUserInfo(String token);
}