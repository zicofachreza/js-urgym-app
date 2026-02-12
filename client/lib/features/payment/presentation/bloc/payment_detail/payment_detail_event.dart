abstract class PaymentDetailEvent {}

class LoadPaymentDetail extends PaymentDetailEvent {
  final String paymentId;
  LoadPaymentDetail(this.paymentId);
}

class OpenPayment extends PaymentDetailEvent {}

class CancelAndReloadPayment extends PaymentDetailEvent {
  final String paymentId;
  CancelAndReloadPayment(this.paymentId);
}
