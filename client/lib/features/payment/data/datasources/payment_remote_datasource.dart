import 'package:dio/dio.dart';

class PaymentRemoteDatasource {
  final Dio dio;
  PaymentRemoteDatasource(this.dio);

  Future<Map<String, dynamic>> createPayment(String planId) async {
    final response = await dio.post('/membership-plans/$planId/pay');

    return response.data['data'];
  }
}
