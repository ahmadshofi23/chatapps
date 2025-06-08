import 'package:chat/domain/entities/message_entity.dart';

abstract class ChatEvent {}

class LoadMessages extends ChatEvent {
  final String senderId;
  final String receiverId;

  LoadMessages(this.senderId, this.receiverId);
}

class SendMessageEvent extends ChatEvent {
  final MessageEntity message;
  SendMessageEvent(this.message);
}
