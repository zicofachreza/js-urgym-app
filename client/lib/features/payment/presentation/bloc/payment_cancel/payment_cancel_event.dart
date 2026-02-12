abstract class PaymentCancelEvent {}

class SubmitCancelPayment extends PaymentCancelEvent {
  final String paymentId;
  SubmitCancelPayment(this.paymentId);
}
