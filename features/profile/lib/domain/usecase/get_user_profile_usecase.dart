import 'package:profile/domain/entity/profile_entity.dart';
import 'package:profile/domain/repository/profile_repository.dart';

class GetUserProfileUsecase {
  final ProfileRepository repository;

  GetUserProfileUsecase(this.repository);

  Future<ProfileEntity> call(String userId) {
    return repository.getProfile(userId);
  }
}
