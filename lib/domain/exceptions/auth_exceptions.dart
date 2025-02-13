class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return 'AuthException: $message';
  }
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException(String message) : super(message);
}

class NetworkException extends AuthException {
  NetworkException(String message) : super(message);
}

class ServerException extends AuthException {
  ServerException(String message) : super(message);
}