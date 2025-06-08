import 'package:shared/common/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getUserProfile(String uid);
}
