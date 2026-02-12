abstract class PaymentEvent {}

class CreatePayment extends PaymentEvent {
  final String planId;
  CreatePayment(this.planId);
}
