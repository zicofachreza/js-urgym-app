import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<String> login(String email, String password) async {
    final result = await remote.login(email, password);
    return result.accessToken;
  }

  @override
  Future<void> register(String username, String email, String password) async {
    await remote.register(username, email, password);
  }
}
