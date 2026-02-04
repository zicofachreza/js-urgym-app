import 'package:dio/dio.dart';

class ProfileRemoteDatasource {
  final Dio dio;

  ProfileRemoteDatasource(this.dio);

  Future<void> logout() async {
    await dio.post('/logout');
  }
}
