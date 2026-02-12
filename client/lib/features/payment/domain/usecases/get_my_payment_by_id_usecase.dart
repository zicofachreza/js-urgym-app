import 'package:client/features/payment/data/models/payment_model.dart';
import 'package:client/features/payment/domain/repositories/payment_repository.dart';

class GetMyPaymentByIdUsecase {
  final PaymentRepository repository;

  GetMyPaymentByIdUsecase(this.repository);

  Future<PaymentModel> execute(String paymentId) {
    return repository.getMyPaymentById(paymentId);
  }
}
