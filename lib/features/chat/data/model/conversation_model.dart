import '../../domain/entity/conversation_entity.dart';
import 'member_model.dart';
import 'message_model.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.type,
    required super.createdAt,
    required super.members,
    super.lastMessage,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'private',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) ?? DateTime.now() : DateTime.now(),
      members: (json['members'] as List<dynamic>?)?.map((e) => MemberModel.fromJson(e)).toList() ?? [],
      lastMessage: json['lastMessage'] != null ? MessageModel.fromJson(json['lastMessage']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'members': members.map((e) => (e as MemberModel).toJson()).toList(),
      if (lastMessage != null) 'lastMessage': (lastMessage as MessageModel).toJson(),
    };
  }
}
