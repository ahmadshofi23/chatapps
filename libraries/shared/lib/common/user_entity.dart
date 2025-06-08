class UserEntity {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final bool? isOnline;

  UserEntity({
    this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.isOnline = false,
  });
}
