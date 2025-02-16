class LoginRequestEntity {
  LoginRequestEntity({
    required this.username,
    required this.password,
    required this.rememberMe,
  });
  final String username;
  final String password;
  final int rememberMe;
}
