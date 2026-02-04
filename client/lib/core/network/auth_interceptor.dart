import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final TokenStorage tokenStorage;
  final AuthRemoteDatasource authRemote;

  AuthInterceptor({
    required this.dio,
    required this.tokenStorage,
    required this.authRemote,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.get();

    final isPublic =
        options.path.contains('/login') ||
        options.path.contains('/register') ||
        options.path.contains('/refresh');

    if (token != null && !isPublic) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final path = err.requestOptions.path;

    // ❌ JANGAN refresh token untuk endpoint public
    if (path.contains('/login') ||
        path.contains('/register') ||
        path.contains('/refresh')) {
      return handler.reject(err); // ⬅️ WAJIB return
    }

    // TOKEN EXPIRED
    if (err.response?.statusCode == 401) {
      try {
        final newToken = await authRemote.refreshToken();
        await tokenStorage.save(newToken);

        // retry original request
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newToken';

        final cloneReq = await dio.fetch(opts);
        return handler.resolve(cloneReq);
      } catch (_) {
        await tokenStorage.clear();
        return handler.reject(err);
      }
    }

    handler.next(err);
  }
}
