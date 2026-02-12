import 'package:client/features/payment/domain/repositories/payment_repository.dart';

class CancelPaymentUsecase {
  final PaymentRepository repository;

  CancelPaymentUsecase(this.repository);

  Future<String> execute(String paymentId) {
    return repository.cancelPayment(paymentId);
  }
}
