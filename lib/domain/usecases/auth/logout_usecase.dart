import '../../repositories/auth_repository.dart';

class LogoutUsecase {
  LogoutUsecase(this._authRepository);
  final AuthRepository _authRepository;

  Future<void> call() async {
    await _authRepository.logout();
  }
}
