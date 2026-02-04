abstract class PaymentRepository {
  Future<Map<String, dynamic>> createPayment(String planId);
}
