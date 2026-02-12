import 'package:client/features/payment/data/models/payment_model.dart';
import 'package:client/features/payment/domain/repositories/payment_repository.dart';

class GetMyPaymentUsecase {
  final PaymentRepository repository;

  GetMyPaymentUsecase(this.repository);

  Future<List<PaymentModel>> execute() {
    return repository.getMyPayments();
  }
}
