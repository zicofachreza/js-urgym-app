abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String snapToken;
  final String redirectUrl;

  PaymentSuccess({required this.snapToken, required this.redirectUrl});
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}
