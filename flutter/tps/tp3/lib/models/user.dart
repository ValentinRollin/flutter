class UserModel {
  final String id;
  final String email;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    this.avatarUrl,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      email: data['email'],
      avatarUrl: data['avatarUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }
}
