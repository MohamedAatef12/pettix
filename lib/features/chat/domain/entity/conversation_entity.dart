import 'package:equatable/equatable.dart';
import 'member_entity.dart';
import 'message_entity.dart';

class ConversationEntity extends Equatable {
  final int id;
  final String type;
  final DateTime createdAt;
  final List<MemberEntity> members;
  final MessageEntity? lastMessage;

  const ConversationEntity({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.members,
    this.lastMessage,
  });

  ConversationEntity copyWith({
    int? id,
    String? type,
    DateTime? createdAt,
    List<MemberEntity>? members,
    MessageEntity? lastMessage,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  @override
  List<Object?> get props => [id, type, createdAt, members, lastMessage];
}
