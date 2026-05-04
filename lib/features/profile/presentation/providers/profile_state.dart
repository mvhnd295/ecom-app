import 'package:fitflow/features/auth/domain/entities/user_entity.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileIdle extends ProfileState {
  const ProfileIdle();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileState {
  final UserEntity user;
  const ProfileSuccess(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}
