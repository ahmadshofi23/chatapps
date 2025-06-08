import 'package:auth/domain/reporisories/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository repository;

  SignOutUsecase(this.repository);

  Future<void> call() => repository.signOut();
}
