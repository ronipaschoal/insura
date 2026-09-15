import '../../domain/entities/user_entity.dart';

class LoginResponseModel {
  const LoginResponseModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  final String id;
  final String name;
  final String email;

  UserEntity toEntity() => UserEntity(id: id, name: name, email: email);
}
