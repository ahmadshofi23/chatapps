import 'package:profile/data/model/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> fetchProfile(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<ProfileModel> fetchProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ProfileModel.fromMock(userId);
  }
}
