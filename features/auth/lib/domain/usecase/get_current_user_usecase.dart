import 'package:auth/domain/reporisories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetCurrentUserUsecase {
  final AuthRepository repository;

  GetCurrentUserUsecase(this.repository);

  User? call() => repository.getCurrentUser();
}
