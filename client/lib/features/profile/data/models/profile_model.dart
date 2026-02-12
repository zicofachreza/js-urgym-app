class ProfileModel {
  final String id;
  final String username;
  final String email;
  final bool isMember;
  final DateTime? membershipExpiresAt;
  final String? membershipBarcodeToken;

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.isMember,
    this.membershipExpiresAt,
    this.membershipBarcodeToken,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      isMember: json['is_member'] as bool,
      membershipExpiresAt: json['membership_expires_at'] != null
          ? DateTime.parse(json['membership_expires_at'])
          : null,
      membershipBarcodeToken: json['membership_barcode_token'],
    );
  }
}
