import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import '../entity/message_entity.dart';
import '../repo/chat_repository.dart';

@lazySingleton
class SendMessageUseCase {
  final ChatRepository _repository;

  const SendMessageUseCase(this._repository);

  Future<Either<Failure, MessageEntity>> call({required int conversationId, required String content, String? imagePath}) {
    return _repository.sendMessage(conversationId, content, imagePath: imagePath);
  }
}
