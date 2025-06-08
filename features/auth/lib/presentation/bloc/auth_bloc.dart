import 'package:auth/domain/usecase/get_current_user_usecase.dart';
import 'package:auth/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:auth/domain/usecase/sign_out_usecase.dart';
import 'package:auth/domain/usecase/update_user_status_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogleUsecase signInWithGoogleUsecase;
  final SignOutUsecase signOutUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final UpdateUserStatusUsecase updateUserStatusUsecase;

  AuthBloc({
    required this.signInWithGoogleUsecase,
    required this.signOutUsecase,
    required this.getCurrentUserUsecase,
    required this.updateUserStatusUsecase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) {
      final user = getCurrentUserUsecase();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signInWithGoogleUsecase();
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthSignOutRequested>((event, emit) async {
      await signOutUsecase();
      emit(AuthUnauthenticated());
    });
  }
}
