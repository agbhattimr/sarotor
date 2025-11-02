class UserProfile {
  final String userId;
  final String? fullName;
  final String? phone;
  final String? role;
  final String? timeOfAvailability;

  UserProfile({
    required this.userId,
    this.fullName,
    this.phone,
    this.role,
    this.timeOfAvailability,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userId: map['user_id'],
      fullName: map['full_name'],
      phone: map['phone'],
      role: map['role'],
      timeOfAvailability: map['time_of_availability'],
    );
  }
}
