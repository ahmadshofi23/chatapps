// domain/usecases/get_user_profile_usecase.dart

import 'package:profile/domain/repository/profile_repository.dart';
import 'package:shared/common/user_entity.dart';

class GetUserProfileUsecase {
  final ProfileRepository repository;

  GetUserProfileUsecase(this.repository);

  Future<UserEntity> call(String uid) {
    return repository.getUserProfile(uid);
  }
}
