import 'package:client/features/payment/data/models/payment_model.dart';

abstract class PaymentHistoryState {}

class PaymentHistoryInitial extends PaymentHistoryState {}

class PaymentHistoryLoading extends PaymentHistoryState {}

class PaymentHistoryLoaded extends PaymentHistoryState {
  final List<PaymentModel> payments;
  PaymentHistoryLoaded(this.payments);
}

class PaymentHistoryError extends PaymentHistoryState {
  final String message;
  PaymentHistoryError(this.message);
}
