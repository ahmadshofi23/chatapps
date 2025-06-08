import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;

  AuthRemoteDataSource({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firestore,
  });

  Future<User> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      await firestore.collection('users').doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        'isOnline': true,
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return user!;
  }

  Future<void> updateUserStatus(String uid, bool isOnline) async {
    await firestore.collection('users').doc(uid).update({
      'isOnline': isOnline,
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signOut() async {
    final uid = firebaseAuth.currentUser?.uid;
    if (uid != null) {
      await updateUserStatus(uid, false);
    }
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }

  User? getCurrentUser() => firebaseAuth.currentUser;
}
