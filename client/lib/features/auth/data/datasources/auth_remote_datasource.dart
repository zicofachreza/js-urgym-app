import 'package:dio/dio.dart';
import '../models/login_response.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource(this.dio);

  // 🔐 LOGIN
  Future<LoginResponse> login(String email, String password) async {
    final response = await dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    return LoginResponse.fromJson(response.data);
  }

  Future<void> register(String username, String email, String password) async {
    await dio.post(
      '/register',
      data: {'username': username, 'email': email, 'password': password},
    );
  }

  // 🔁 REFRESH TOKEN
  Future<String> refreshToken() async {
    final response = await dio.post('/refresh');
    return response.data['data']['accessToken'];
  }
}
