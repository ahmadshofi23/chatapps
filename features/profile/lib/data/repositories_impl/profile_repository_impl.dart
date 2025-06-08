import 'package:profile/domain/repository/profile_repository.dart';
import 'package:shared/common/user_entity.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<UserEntity> getUserProfile(String uid) {
    return remote.getUserProfile(uid);
  }
}
