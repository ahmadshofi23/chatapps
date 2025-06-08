import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/common/user_entity.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSource(this.firestore);

  Stream<List<UserEntity>> getOnlineUsers() {
    return firestore.collection('users').where('isOnline').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return UserEntity(
          uid: doc.id,
          displayName: data['name'],
          email: data['email'],
          isOnline: data['isOnline'] ?? false,
        );
      }).toList();
    });
  }
}
