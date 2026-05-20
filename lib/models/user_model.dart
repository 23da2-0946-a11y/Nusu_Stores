class UserModel {
  final String uid;
  final String name;
  final String email;
  final String membership;
  final String profileImage;
  final DateTime createdAt;
  final String role;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.membership,
    required this.profileImage,
    required this.createdAt,
    this.role = 'user',
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      membership: data['membership'] ?? 'Silver',
      profileImage: data['profileImage'] ?? '',
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] is String ? DateTime.parse(data['createdAt']) : (data['createdAt'] as dynamic).toDate())
          : DateTime.now(),
      role: data['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'membership': membership,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'role': role,
    };
  }
}
