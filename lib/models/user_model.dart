class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String village;
  final String district;
  final String state;
  final String role; // Farmer, Farm Worker, Admin

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.village,
    required this.district,
    required this.state,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'village': village,
      'district': district,
      'state': state,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      village: map['village'] ?? '',
      district: map['district'] ?? '',
      state: map['state'] ?? '',
      role: map['role'] ?? 'Farmer',
    );
  }
}
