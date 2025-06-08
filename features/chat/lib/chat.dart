// features/chat/chat_module.dart
import 'package:chat/data/datasources/chat_remote_data_source.dart';
import 'package:chat/data/repositories_impl/chat_repository_impl.dart';
import 'package:chat/domain/repository/chat_repository.dart';
import 'package:chat/domain/usecase/mark_message_read_usecase.dart';
import 'package:chat/domain/usecase/send_message_usecase.dart';
import 'package:chat/presentation/bloc/chat_bloc.dart';
import 'package:chat/presentation/ui/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:chat/domain/usecase/get_messages_stream_usecase.dart';

class ChatModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton((i) => FirebaseFirestore.instance),
    Bind.singleton((i) => ChatRemoteDataSource(i())),
    Bind<ChatRepository>((i) => ChatRepositoryImpl(i())),
    Bind.singleton((i) => GetMessagesStreamUsecase(i())),
    Bind.singleton((i) => SendMessageUsecase(i())),
    Bind.singleton((i) => MarkMessageReadUsecase(i())),

    Bind.factory(
      (i) => ChatBloc(
        getMessagesStream: i<GetMessagesStreamUsecase>(),
        sendMessage: i<SendMessageUsecase>(),
        markMessageReadUsecase: i<MarkMessageReadUsecase>(),
      ),
    ),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      '/:receiverId/:receiverName',
      child: (_, args) {
        final currentUser = Modular.args.data['currentUser'];
        return BlocProvider(
          create: (context) => Modular.get<ChatBloc>(),
          child: ChatPage(
            currentUser: currentUser,
            receiverId: args.params['receiverId']!,
            receiverName: args.params['receiverName']!,
          ),
        );
      },
    ),
  ];
}
