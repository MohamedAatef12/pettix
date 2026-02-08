import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/data/models/comments_like_model.dart';

import '../../domain/entities/comments_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.text,
    required super.creationDate,
    required super.author,
    required super.parentCommentId,
    required super.replies,
    required super.postId,
    required super.likes
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      postId: json['postId'] as int,
      text: json['text'] ?? '',
      creationDate: json['creationDate'] ?? '',
      author: AuthorModel.fromJson(json['author']),
      parentCommentId: json['parentCommentId'] as int?,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => CommentsLikeModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'creationDate': creationDate,
      'parentCommentId': parentCommentId,
      'replies': replies,
      'postId': postId,
      'likes':likes
    };
  }

  CommentModel.fromEntity(CommentEntity commentEntity)
    : super(
        id: commentEntity.id,
        text: commentEntity.text,
        author: commentEntity.author,
        creationDate: commentEntity.creationDate,
        parentCommentId: commentEntity.parentCommentId,
        replies: commentEntity.replies,
        postId: commentEntity.postId,
      likes: commentEntity.likes
      );

  CommentEntity toEntity(CommentModel commentModel) => CommentEntity(
    id: commentModel.id,
    text: commentModel.text,
    postId: commentModel.postId,
    author: commentModel.author,
    creationDate: commentModel.creationDate,
    parentCommentId: commentModel.parentCommentId,
    replies: commentModel.replies,
    likes: commentModel.likes
  );
}
