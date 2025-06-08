import 'package:chat/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  ChatRemoteDataSource(this.firestore);

  String getChatId(String userA, String userB) {
    return userA.hashCode <= userB.hashCode ? '$userA-$userB' : '$userB-$userA';
  }

  Stream<List<MessageEntity>> getMessages(String senderId, String receiverId) {
    final chatId = getChatId(senderId, receiverId);

    return firestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                return MessageEntity(
                  id: doc.id,
                  senderId: data['senderId'],
                  receiverId: data['receiverId'],
                  text: data['text'],
                  timestamp: (data['timestamp'] as Timestamp).toDate(),
                  isRead: data['isRead'] ?? false,
                );
              }).toList(),
        );
  }

  Future<void> sendMessage(MessageEntity message) async {
    final chatId = getChatId(message.senderId, message.receiverId);
    await firestore.collection('messages').add({
      'chatId': chatId,
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'text': message.text,
      'timestamp': message.timestamp,
      'participants': [message.senderId, message.receiverId],
      'isRead': false,
    });
  }
}
