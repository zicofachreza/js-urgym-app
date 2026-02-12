import 'package:client/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:client/features/payment/data/models/payment_model.dart';
import 'package:client/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDatasource remote;

  PaymentRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> createPayment(String planId) {
    return remote.createPayment(planId);
  }

  @override
  Future<String> cancelPayment(String paymentId) {
    return remote.cancelPayment(paymentId);
  }

  @override
  Future<List<PaymentModel>> getMyPayments() {
    return remote.getMyPayments();
  }

  @override
  Future<PaymentModel> getMyPaymentById(String paymentId) {
    return remote.getMyPaymentById(paymentId);
  }
}
