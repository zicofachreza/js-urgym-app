class MembershipPlanModel {
  final String id;
  final String name;
  final int durationMonths;
  final int price;
  final int? discountPrice;
  final String description;

  MembershipPlanModel({
    required this.id,
    required this.name,
    required this.durationMonths,
    required this.price,
    this.discountPrice,
    required this.description,
  });

  factory MembershipPlanModel.fromJson(Map<String, dynamic> json) {
    return MembershipPlanModel(
      id: json['id'],
      name: json['name'],
      durationMonths: json['duration_months'],
      price: json['price'],
      discountPrice: json['discount_price'],
      description: json['description'],
    );
  }
}
