import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import 'auth_interceptor.dart';
import '../storage/token_storage.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {'Content-Type': 'application/json'},
        receiveDataWhenStatusError: true,
      ),
    );

    final refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    final tokenStorage = TokenStorage();
    final authRemote = AuthRemoteDatasource(refreshDio);

    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        tokenStorage: tokenStorage,
        authRemote: authRemote,
      ),
    );

    return dio;
  }
}
