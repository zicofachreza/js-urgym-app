import 'package:client/features/payment/data/models/payment_model.dart';

abstract class PaymentDetailState {}

class PaymentDetailInitial extends PaymentDetailState {}

class PaymentDetailLoading extends PaymentDetailState {}

class PaymentDetailLoaded extends PaymentDetailState {
  final PaymentModel payment;
  PaymentDetailLoaded(this.payment);
}

class PaymentDetailOpenPayment extends PaymentDetailState {
  final String snapUrl;
  PaymentDetailOpenPayment(this.snapUrl);
}

class PaymentDetailCancelSuccess extends PaymentDetailState {
  final String message;
  PaymentDetailCancelSuccess(this.message);
}

class PaymentDetailError extends PaymentDetailState {
  final String message;
  PaymentDetailError(this.message);
}
