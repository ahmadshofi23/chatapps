// profile_module.dart
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profile/domain/repository/profile_repository.dart';
import 'package:profile/domain/usecase/get_user_profile_usecase.dart';
import 'package:profile/presentation/ui/profile_page.dart';
import 'data/datasources/profile_remote_data_source.dart';
import 'data/repositories_impl/profile_repository_impl.dart';
import 'presentation/bloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeatureProfileModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton((i) => ProfileRemoteDataSource(FirebaseFirestore.instance)),
    Bind<ProfileRepository>((i) => ProfileRepositoryImpl(i())),
    Bind((i) => GetUserProfileUsecase(i())),
    Bind.factory((i) => ProfileBloc(i())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      '/:uid',
      child:
          (_, args) => BlocProvider(
            create: (context) => Modular.get<ProfileBloc>(),
            child: ProfilePage(uid: args.params['uid']!),
          ),
    ),
  ];
}
