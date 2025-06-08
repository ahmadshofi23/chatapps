import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared/common/user_entity.dart';

class SharedModule extends Module {
  // void exportBinds(i) {
  //   i.add<NamedRoutes>(() => NamedRoutes(), export: true);
  // }

  @override
  List<Bind> get binds => [Bind((_) => UserEntity(), export: true)];

  List<ModularRoute> get routes => [];
}
