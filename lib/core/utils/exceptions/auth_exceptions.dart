class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => 'AuthException: $message';
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException(super.message);
}

class NetworkException extends AuthException {
  NetworkException(super.message);
}

class ServerException extends AuthException {
  ServerException(super.message);
}
