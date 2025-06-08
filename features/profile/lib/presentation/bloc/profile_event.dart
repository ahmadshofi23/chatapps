abstract class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {
  final String uid;
  LoadUserProfile(this.uid);
}
