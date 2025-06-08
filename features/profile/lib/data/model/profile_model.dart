import 'package:shared/common/user_entity.dart';

class ProfileModel extends UserEntity {
  ProfileModel({
    required super.uid,
    required super.displayName,
    required super.email,
    required super.photoUrl,
    required super.isOnline,
  });

  factory ProfileModel.fromMock(String id) {
    return ProfileModel(
      uid: id,
      displayName: 'User $id',
      email: 'user$id@example.com',
      photoUrl: 'https://i.pravatar.cc/150?img=$id',
      isOnline: int.parse(id) % 2 == 0,
    );
  }
}
