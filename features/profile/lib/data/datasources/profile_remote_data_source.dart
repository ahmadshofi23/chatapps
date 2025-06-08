import 'package:shared/common/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSource(this.firestore);

  Future<UserEntity> getUserProfile(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    final data = doc.data()!;
    return UserEntity(
      uid: uid,
      displayName: data['name'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      isOnline: data['isOnline'],
    );
  }
}
