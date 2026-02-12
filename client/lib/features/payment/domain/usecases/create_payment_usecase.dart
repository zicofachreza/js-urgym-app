import 'package:client/features/payment/domain/repositories/payment_repository.dart';

class CreatePaymentUseCase {
  final PaymentRepository repository;

  CreatePaymentUseCase(this.repository);

  Future<Map<String, dynamic>> execute(String planId) {
    return repository.createPayment(planId);
  }
}
