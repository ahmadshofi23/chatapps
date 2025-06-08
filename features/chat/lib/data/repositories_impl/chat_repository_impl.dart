import 'package:chat/data/datasources/chat_remote_data_source.dart';
import 'package:chat/domain/entities/message_entity.dart';
import 'package:chat/domain/repository/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;
  ChatRepositoryImpl(this.remote);

  @override
  Stream<List<MessageEntity>> getMessages(String senderId, String receiverId) {
    return remote.getMessages(senderId, receiverId);
  }

  @override
  Future<void> sendMessage(MessageEntity message) {
    return remote.sendMessage(message);
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    return await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }
}
