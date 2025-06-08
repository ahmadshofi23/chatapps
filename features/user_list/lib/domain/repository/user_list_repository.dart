import 'package:shared/common/user_entity.dart';

abstract class UserRepository {
  Stream<List<UserEntity>> getOnlineUsers();
}
