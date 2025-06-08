import 'package:profile/domain/entity/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.photoUrl,
    required super.isOnline,
  });

  factory ProfileModel.fromMock(String id) {
    return ProfileModel(
      id: id,
      name: 'User $id',
      email: 'user$id@example.com',
      photoUrl: 'https://i.pravatar.cc/150?img=$id',
      isOnline: int.parse(id) % 2 == 0,
    );
  }
}
