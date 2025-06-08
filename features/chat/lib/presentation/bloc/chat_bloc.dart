import 'package:chat/domain/usecase/get_messages_stream_usecase.dart';
import 'package:chat/domain/usecase/mark_message_read_usecase.dart';
import 'package:chat/domain/usecase/send_message_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessagesStreamUsecase getMessagesStream;
  final SendMessageUsecase sendMessage;
  final MarkMessageReadUsecase markMessageReadUsecase;

  ChatBloc({
    required this.getMessagesStream,
    required this.sendMessage,
    required this.markMessageReadUsecase,
  }) : super(ChatInitial()) {
    on<LoadMessages>((event, emit) async {
      emit(ChatLoading());
      await emit.forEach(
        getMessagesStream(event.senderId, event.receiverId),
        onData: (messages) {
          // Tandai pesan masuk (yang belum dibaca) sebagai read
          for (final msg in messages) {
            if (msg.receiverId == event.senderId && !msg.isRead) {
              markMessageReadUsecase.call(msg.id);
            }
          }

          return ChatLoaded(messages);
        },
        onError: (e, _) => ChatError(e.toString()),
      );
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        await sendMessage(event.message);
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
