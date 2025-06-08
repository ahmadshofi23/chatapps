// ignore: depend_on_referenced_packages
import 'package:auth/domain/usecase/get_current_user_usecase.dart';
import 'package:auth/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:auth/domain/usecase/sign_out_usecase.dart';
import 'package:auth/domain/usecase/update_user_status_usecase.dart';
import 'package:auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_list/data/datasources/user_remote_data_sources.dart';
import 'package:user_list/data/repositories_impl/user_list_repository_impl.dart';
import 'package:user_list/domain/repository/user_list_repository.dart';
import 'package:user_list/domain/usecase/get_online_users_usecase.dart';
import 'package:user_list/presentation/bloc/user_list_bloc.dart';
import 'package:user_list/presentation/bloc/user_list_event.dart';
import 'package:user_list/presentation/ui/user_list_page.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class FeatureUserListModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton((i) => FirebaseFirestore.instance),

    Bind.singleton((i) => UserRemoteDataSource(i())),

    Bind.singleton<UserRepository>((i) => UserRepositoryImpl(i())),

    Bind.singleton((i) => GetOnlineUsersUsecase(i())),
    Bind.singleton((i) => UserListBloc(getOnlineUsers: i())),

    Bind.singleton((i) => SignInWithGoogleUsecase(i())),
    Bind.singleton((i) => SignOutUsecase(i())),
    Bind.singleton((i) => GetCurrentUserUsecase(i())),
    Bind.singleton((i) => UpdateUserStatusUsecase(i())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      Modular.initialRoute,
      child: (_, args) {
        final currentUser = args.data['currentUser'];
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create:
                  (context) => UserListBloc(
                    getOnlineUsers: Modular.get<GetOnlineUsersUsecase>(),
                  )..add(LoadOnlineUsers()),
            ),
            BlocProvider(
              create:
                  (context) => AuthBloc(
                    getCurrentUserUsecase: Modular.get<GetCurrentUserUsecase>(),
                    signInWithGoogleUsecase:
                        Modular.get<SignInWithGoogleUsecase>(),
                    signOutUsecase: Modular.get<SignOutUsecase>(),
                    updateUserStatusUsecase:
                        Modular.get<UpdateUserStatusUsecase>(),
                  ),
            ),
          ],
          child: UserListPage(currentUser: currentUser),
        );
      },
    ),
  ];
}
