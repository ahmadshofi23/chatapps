import 'package:auth/domain/reporisories/auth_repository.dart';

class UpdateUserStatusUsecase {
  final AuthRepository repository;

  UpdateUserStatusUsecase(this.repository);

  Future<void> call(String uid, bool isOnline) =>
      repository.updateUserStatus(uid, isOnline);
}
