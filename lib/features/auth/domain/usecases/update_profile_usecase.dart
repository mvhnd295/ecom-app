import 'package:fpdart/fpdart.dart';
import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/auth/domain/entities/address.dart';
import 'package:fitflow/features/auth/domain/entities/user_entity.dart';
import 'package:fitflow/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileParams {
  final String userId;
  final String name;
  final String phone;
  final Address? address;

  const UpdateProfileParams({
    required this.userId,
    required this.name,
    required this.phone,
    this.address,
  });
}

class UpdateProfileUsecase {
  final AuthRepository _repository;
  const UpdateProfileUsecase(this._repository);

  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) =>
      _repository.updateProfile(
        userId: params.userId,
        name: params.name,
        phone: params.phone,
        address: params.address,
      );
}
