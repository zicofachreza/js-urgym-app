import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> execute(String username, String email, String password) {
    return repository.register(username, email, password);
  }
}
