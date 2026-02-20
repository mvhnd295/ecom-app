import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final bool isVerified;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.isVerified = false,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, phone, avatarUrl, isVerified, createdAt];
}
