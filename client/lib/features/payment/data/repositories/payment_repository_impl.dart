import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDatasource remote;

  PaymentRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> createPayment(String planId) {
    return remote.createPayment(planId);
  }
}
