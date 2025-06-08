import 'package:chat/domain/entities/message_entity.dart';
import 'package:chat/domain/repository/chat_repository.dart';

class SendMessageUsecase {
  final ChatRepository repository;
  SendMessageUsecase(this.repository);

  Future<void> call(MessageEntity message) => repository.sendMessage(message);
}
