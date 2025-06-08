import 'package:chat/domain/entities/message_entity.dart';
import 'package:chat/domain/repository/chat_repository.dart';

class GetMessagesStreamUsecase {
  final ChatRepository repository;
  GetMessagesStreamUsecase(this.repository);

  Stream<List<MessageEntity>> call(String senderId, String receiverId) =>
      repository.getMessages(senderId, receiverId);
}
