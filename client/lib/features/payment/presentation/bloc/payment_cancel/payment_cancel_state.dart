abstract class PaymentCancelState {}

class PaymentCancelInitial extends PaymentCancelState {}

class PaymentCancelLoading extends PaymentCancelState {}

class PaymentCancelSuccess extends PaymentCancelState {
  final String message;
  PaymentCancelSuccess(this.message);
}

class PaymentCancelError extends PaymentCancelState {
  final String message;
  PaymentCancelError(this.message);
}
