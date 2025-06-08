import 'package:flutter_modular/flutter_modular.dart';
import 'package:profile/data/repositories_impl/profile_repository_impl.dart';
import 'package:profile/domain/repository/profile_repository.dart';
import 'package:profile/domain/usecase/get_user_profile_usecase.dart';
import 'package:profile/presentation/ui/profile_page.dart';

import 'data/datasources/profile_remote_data_source.dart';
import 'presentation/bloc/profile_bloc.dart';

class ProfileModule extends Module {
  @override
  List<Bind> get binds => [
    // Data layer
    Bind<ProfileRemoteDataSource>((i) => ProfileRemoteDataSourceImpl()),

    // Repository
    Bind<ProfileRepository>((i) => ProfileRepositoryImpl(i())),

    // UseCase
    Bind((i) => GetUserProfileUsecase(i())),

    // Bloc
    Bind((i) => ProfileBloc(getProfile: i())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      Modular.initialRoute,
      child: (_, args) {
        final userId = args.data as String? ?? '1';
        return ProfilePage(userId: userId);
      },
    ),
  ];
}
