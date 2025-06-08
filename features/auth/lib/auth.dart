import 'package:auth/data/datasource/auth_remote_data_source.dart';
import 'package:auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:auth/domain/reporisories/auth_repository.dart';
import 'package:auth/domain/usecase/get_current_user_usecase.dart';
import 'package:auth/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:auth/domain/usecase/sign_out_usecase.dart';
import 'package:auth/domain/usecase/update_user_status_usecase.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'presentation/bloc/auth_bloc.dart';
import 'presentation/pages/login_page.dart';

class FeatureAuthModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton((i) => FirebaseAuth.instance),
    Bind.singleton((i) => FirebaseFirestore.instance),
    Bind.singleton((i) => GoogleSignIn()),

    Bind.singleton(
      (i) => AuthRemoteDataSource(
        firebaseAuth: i(),
        googleSignIn: i(),
        firestore: i(),
      ),
    ),

    Bind.singleton<AuthRepository>((i) => AuthRepositoryImpl(i())),

    Bind.singleton((i) => SignInWithGoogleUsecase(i())),
    Bind.singleton((i) => SignOutUsecase(i())),
    Bind.singleton((i) => GetCurrentUserUsecase(i())),
    Bind.singleton((i) => UpdateUserStatusUsecase(i())),

    Bind.singleton(
      (i) => AuthBloc(
        signInWithGoogleUsecase: i(),
        signOutUsecase: i(),
        getCurrentUserUsecase: i(),
        updateUserStatusUsecase: i(),
      ),
    ),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      Modular.initialRoute,
      child:
          (_, __) => BlocProvider(
            create:
                (context) => AuthBloc(
                  getCurrentUserUsecase: Modular.get<GetCurrentUserUsecase>(),
                  signInWithGoogleUsecase:
                      Modular.get<SignInWithGoogleUsecase>(),
                  signOutUsecase: Modular.get<SignOutUsecase>(),
                  updateUserStatusUsecase:
                      Modular.get<UpdateUserStatusUsecase>(),
                )..add(AuthCheckRequested()),
            child: LoginPage(),
          ),
    ),
  ];
}
