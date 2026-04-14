import '../../domain/entity/member_entity.dart';
import 'chat_user_model.dart';

class MemberModel extends MemberEntity {
  const MemberModel({
    required super.id,
    required super.conversationId,
    required super.userId,
    required super.joinedAt,
    super.lastReadMessageId,
    required super.user,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] ?? 0,
      conversationId: json['conversationId'] ?? 0,
      userId: json['userId'] ?? 0,
      joinedAt: json['joinedAt'] != null ? DateTime.tryParse(json['joinedAt']) ?? DateTime.now() : DateTime.now(),
      lastReadMessageId: json['lastReadMessageId'],
      user: ChatUserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'userId': userId,
      'joinedAt': joinedAt.toIso8601String(),
      'lastReadMessageId': lastReadMessageId,
      'user': (user as ChatUserModel).toJson(),
    };
  }
}
