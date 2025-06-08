import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/domain/usecase/get_user_profile_usecase.dart';
import 'package:profile/presentation/bloc/profile_event.dart';
import 'package:profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUsecase getProfile;

  ProfileBloc({required this.getProfile}) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await getProfile(event.userId);
        emit(ProfileLoaded(profile));
      } catch (_) {
        emit(ProfileError("Failed to load profile"));
      }
    });
  }
}
