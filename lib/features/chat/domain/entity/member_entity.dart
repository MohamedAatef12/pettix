import 'package:equatable/equatable.dart';
import 'chat_user_entity.dart';

class MemberEntity extends Equatable {
  final int id;
  final int conversationId;
  final int userId;
  final DateTime joinedAt;
  final int? lastReadMessageId;
  final ChatUserEntity user;

  const MemberEntity({
    required this.id,
    required this.conversationId,
    required this.userId,
    required this.joinedAt,
    this.lastReadMessageId,
    required this.user,
  });

  @override
  List<Object?> get props => [id, conversationId, userId, joinedAt, lastReadMessageId, user];
}
