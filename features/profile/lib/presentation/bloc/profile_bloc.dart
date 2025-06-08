import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/domain/usecase/get_user_profile_usecase.dart';
import 'package:profile/presentation/bloc/profile_event.dart';
import 'package:profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUsecase getUserProfile;

  ProfileBloc(this.getUserProfile) : super(ProfileInitial()) {
    on<LoadUserProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await getUserProfile(event.uid);
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
