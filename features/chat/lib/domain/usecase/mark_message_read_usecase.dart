import 'package:chat/domain/repository/chat_repository.dart';

class MarkMessageReadUsecase {
  final ChatRepository repository;
  MarkMessageReadUsecase(this.repository);

  Future<void> call(String messageId) =>
      repository.markMessageAsRead(messageId);
}
