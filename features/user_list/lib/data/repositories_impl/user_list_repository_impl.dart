import 'package:shared/common/user_entity.dart';
import 'package:user_list/data/datasources/user_remote_data_sources.dart';
import 'package:user_list/domain/repository/user_list_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<UserEntity>> getOnlineUsers() =>
      remoteDataSource.getOnlineUsers();
}
