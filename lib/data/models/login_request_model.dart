class LoginRequest {
  final String username;
  final String password;
  final int rememberMe;

  LoginRequest({
    required this.username,
    required this.password,
    required this.rememberMe,
  });
}