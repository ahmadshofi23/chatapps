import 'package:auth/data/datasource/auth_remote_data_source.dart';
import 'package:auth/domain/reporisories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<User> signInWithGoogle() => remote.signInWithGoogle();

  @override
  Future<void> signOut() => remote.signOut();

  @override
  Future<void> updateUserStatus(String uid, bool isOnline) =>
      remote.updateUserStatus(uid, isOnline);

  @override
  User? getCurrentUser() => remote.getCurrentUser();
}
