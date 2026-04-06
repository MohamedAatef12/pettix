import 'package:equatable/equatable.dart';
import 'package:pettix/features/home/domain/entities/author_entity.dart';
import 'package:pettix/features/home/domain/entities/comment_like_entity.dart';

class CommentEntity extends Equatable {
  final int id;
  final int postId;
  final String text;
  final String creationDate;
  final AuthorEntity author;
  final int? parentCommentId;
  final int status;
  final List<CommentEntity> replies;
  final List<CommentLikeEntity> likes;

  const CommentEntity({
    required this.id,
    required this.text,
    required this.postId,
    required this.author,
    required this.creationDate,
    this.parentCommentId,
    required this.status,
    required this.replies,
    required this.likes,
  });

  CommentEntity copyWith({
    int? id,
    int? postId,
    String? text,
    String? creationDate,
    AuthorEntity? author,
    int? parentCommentId,
    int? status,
    List<CommentEntity>? replies,
    List<CommentLikeEntity>? likes,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      postId: postId ?? this.postId,
      author: author ?? this.author,
      creationDate: creationDate ?? this.creationDate,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      status: status ?? this.status,
      replies: replies ?? List<CommentEntity>.from(this.replies),
      likes: likes ?? List<CommentLikeEntity>.from(this.likes),
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
    status,
    replies,
    likes,
  ];
}
