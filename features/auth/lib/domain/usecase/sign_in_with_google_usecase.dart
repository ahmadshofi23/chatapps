import 'package:auth/domain/reporisories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInWithGoogleUsecase {
  final AuthRepository repository;

  SignInWithGoogleUsecase(this.repository);

  Future<User> call() => repository.signInWithGoogle();
}
