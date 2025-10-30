import 'package:equatable/equatable.dart';
import 'package:pettix/features/home/domain/entities/author_entity.dart';

class CommentEntity extends Equatable {
  final int id;
  final int postId;
  final String text;
  final String creationDate;
  final AuthorEntity author;
  final int? parentCommentId;
  final List<CommentEntity> replies;

  const CommentEntity({
    required this.id,
    required this.text,
    required this.postId,
    required this.author,
    required this.creationDate,
    this.parentCommentId,
    required this.replies,
  });

  CommentEntity copyWith({
    int? id,
    int? postId,
    String? text,
    String? creationDate,
    AuthorEntity? author,
    int? parentCommentId,
    List<CommentEntity>? replies,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      postId: postId ?? this.postId,
      author: author ?? this.author,
      creationDate: creationDate ?? this.creationDate,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replies: replies ?? List<CommentEntity>.from(this.replies),
    );
  }

  @override
  List<Object?> get props => [
    id,
    text,
    postId,
    author,
    creationDate,
    parentCommentId,
    replies,
  ];
}
