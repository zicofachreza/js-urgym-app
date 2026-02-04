abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<void> register(String username, String email, String password);
}
