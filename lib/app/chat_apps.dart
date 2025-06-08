import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_modular/flutter_modular.dart';
import 'package:chat/chat.dart';
import 'package:profile/profile.dart';
import 'package:user_list/user_list.dart';
// import 'package:profile/profile.dart';
// import 'package:user_list/user_list.dart';
// import 'package:profile/profile.dart';

class AppModule extends Module {
  @override
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
    ModuleRoute('/auth', module: FeatureAuthModule()),
    ModuleRoute('/chat', module: FeatureChatModule()),
    RedirectRoute('/', to: '/auth'),
    ModuleRoute('/user-list', module: FeatureUserListModule()),
    ModuleRoute('/profile', module: FeatureProfileModule()),
  ];
}

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
