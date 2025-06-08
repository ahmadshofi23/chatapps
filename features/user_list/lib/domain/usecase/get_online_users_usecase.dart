import 'package:shared/common/user_entity.dart';
import 'package:user_list/domain/repository/user_list_repository.dart';

class GetOnlineUsersUsecase {
  final UserRepository repository;

  GetOnlineUsersUsecase(this.repository);

  Stream<List<UserEntity>> call() {
    return repository.getOnlineUsers();
  }
}
