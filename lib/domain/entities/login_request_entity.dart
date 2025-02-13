class LoginRequestEntity {
  final String username;
  final String password;
  final int rememberMe;

  LoginRequestEntity({
    required this.username,
    required this.password,
    required this.rememberMe,
  });
}
