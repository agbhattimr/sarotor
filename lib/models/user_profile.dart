class UserProfile {
  final String userId;
  final String? fullName;
  final String? phone;
  final String? role;

  UserProfile({
    required this.userId,
    this.fullName,
    this.phone,
    this.role,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userId: map['user_id'],
      fullName: map['full_name'],
      phone: map['phone'],
      role: map['role'],
    );
  }
}
