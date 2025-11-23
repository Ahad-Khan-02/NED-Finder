class UserModel {
  final int id;
  final String fullname;
  final String email;
  final String role;
  final String? fieldOfStudy;
  final int? year;
  final String createdAt;

  UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.role,
    this.fieldOfStudy,
    this.year,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      fieldOfStudy: json['field_of_study'] as String?,
      year: json['year'] as int?,
      createdAt: json['created_at'] as String,
    );
  }

  String get capitalizedRole {
    if (role.isEmpty) return '';
    return role[0].toUpperCase() + role.substring(1);
  }
}