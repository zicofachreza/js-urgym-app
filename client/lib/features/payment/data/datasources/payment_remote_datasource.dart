import 'package:client/features/payment/data/models/payment_model.dart';
import 'package:dio/dio.dart';

class PaymentRemoteDatasource {
  final Dio dio;
  PaymentRemoteDatasource(this.dio);

  Future<Map<String, dynamic>> createPayment(String planId) async {
    final response = await dio.post('/membership-plans/$planId/pay');

    return response.data['data'];
  }

  Future<String> cancelPayment(String paymentId) async {
    final response = await dio.post('/payments/$paymentId/cancel');

    return response.data['message'];
  }

  Future<List<PaymentModel>> getMyPayments() async {
    final response = await dio.get('/payments/me');

    final List data = response.data['data'];

    return data.map((e) => PaymentModel.fromJson(e)).toList();
  }

  Future<PaymentModel> getMyPaymentById(String paymentId) async {
    final response = await dio.get('/payments/$paymentId');

    return PaymentModel.fromJson(response.data['data']);
  }
}
