import '../entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> getMessages(String senderId, String receiverId);
  Future<void> sendMessage(MessageEntity message);
  Future<void> markMessageAsRead(String messageId);
}
