import 'package:client/features/payment/data/models/payment_model.dart';

abstract class PaymentRepository {
  Future<Map<String, dynamic>> createPayment(String planId);
  Future<String> cancelPayment(String paymentId);
  Future<List<PaymentModel>> getMyPayments();
  Future<PaymentModel> getMyPaymentById(String paymentId);
}
