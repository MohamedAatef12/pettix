import 'package:pettix/features/home/data/models/author_model.dart';

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
      );

  CommentEntity toEntity(CommentModel commentModel) => CommentEntity(
    id: commentModel.id,
    text: commentModel.text,
    postId: commentModel.postId,
    author: commentModel.author,
    creationDate: commentModel.creationDate,
    parentCommentId: commentModel.parentCommentId,
    replies: commentModel.replies,
  );
}
