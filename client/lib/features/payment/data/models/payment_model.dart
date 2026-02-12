class PaymentModel {
  final String id;
  final int amount;
  final String status;
  final String midtransOrderId;
  final String? snapUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String membershipName;
  final int durationMonths;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.midtransOrderId,
    this.snapUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.membershipName,
    required this.durationMonths,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      amount: json['amount'],
      status: json['status'],
      midtransOrderId: json['midtrans_order_id'],
      snapUrl: json['redirect_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      membershipName: json['membership_plan']['name'],
      durationMonths: json['membership_plan']['duration_months'],
    );
  }
}
