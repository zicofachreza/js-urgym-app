import '../repositories/profile_repository.dart';

class LogoutUseCase {
  final ProfileRepository repository;

  LogoutUseCase(this.repository);

  Future<void> execute() {
    return repository.logout();
  }
}
