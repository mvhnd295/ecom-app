import 'package:fitflow/core/di/injection_container.dart';
import 'package:fitflow/features/auth/domain/entities/address.dart';
import 'package:fitflow/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fitflow/features/profile/presentation/providers/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNotifier extends Notifier<ProfileState> {
  late final UpdateProfileUsecase _updateProfileUsecase;

  @override
  ProfileState build() {
    _updateProfileUsecase = sl<UpdateProfileUsecase>();
    return const ProfileIdle();
  }

  Future<void> updateProfile({
    required String userId,
    required String name,
    required String phone,
    Address? address,
  }) async {
    state = const ProfileLoading();

    final result = await _updateProfileUsecase(
      UpdateProfileParams(
        userId: userId,
        name: name,
        phone: phone,
        address: address,
      ),
    );

    result.fold(
      (failure) => state = ProfileError(failure.message),
      (user) {
        // Sync the updated user back into the global auth state.
        ref.read(authProvider.notifier).updateUser(user);
        state = ProfileSuccess(user);
      },
    );
  }

  void reset() => state = const ProfileIdle();
}

final profileProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
