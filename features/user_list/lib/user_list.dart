// ignore: depend_on_referenced_packages
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

class UserListModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton((i) => FirebaseFirestore.instance),

    Bind.singleton((i) => UserRemoteDataSource(i())),

    Bind.singleton<UserRepository>((i) => UserRepositoryImpl(i())),

    Bind.singleton((i) => GetOnlineUsersUsecase(i())), // ✅ Ini WAJIB!
    Bind.singleton((i) => UserListBloc(getOnlineUsers: i())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      Modular.initialRoute,
      child: (_, args) {
        final currentUser = args.data['currentUser'];
        return BlocProvider(
          create:
              (context) => UserListBloc(
                getOnlineUsers: Modular.get<GetOnlineUsersUsecase>(),
              )..add(LoadOnlineUsers()),
          child: UserListPage(currentUser: currentUser),
        );
      },
    ),
  ];
}
