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
    required super.status,
    required super.replies,
    required super.postId,
    required super.likes,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: (json['id'] ?? 0) is int ? json['id'] ?? 0 : int.tryParse(json['id'].toString()) ?? 0,
      postId: (json['postId'] ?? 0) is int ? json['postId'] ?? 0 : int.tryParse(json['postId'].toString()) ?? 0,
      text: json['text']?.toString() ?? '',
      creationDate: json['creationDate']?.toString() ?? '',
      status: json['status'] as int? ?? 1,
      author: json['author'] != null
          ? AuthorModel.fromJson(json['author'] as Map<String, dynamic>)
          : const AuthorModel(
        id: 0,
        nameAr: '',
        nameEn: '',
        avatar: '',
        email: null,
        phone: null,
        genderId: null,
        genderName: null,
        contactTypeId: 4,
        statusId: 1,
        age: null,
      ),
      parentCommentId: json['parentCommentId'] is int
          ? json['parentCommentId']
          : int.tryParse(json['parentCommentId']?.toString() ?? ''),
      replies: (json['replies'] as List<dynamic>?)
          ?.where((e) => e is Map<String, dynamic>)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
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
      'author': (author as AuthorModel).toJson(),
      'creationDate': creationDate,
      'parentCommentId': parentCommentId,
      'status': status,
      'replies': replies.map((e) => (e as CommentModel).toJson()).toList(),
      'postId': postId,
      'likes': likes.map((e) => (e as CommentsLikeModel).toJson()).toList(),
    };
  }

  CommentModel.fromEntity(CommentEntity entity)
      : super(
    id: entity.id,
    text: entity.text,
    author: entity.author,
    creationDate: entity.creationDate,
    parentCommentId: entity.parentCommentId,
    status: entity.status,
    replies: entity.replies,
    postId: entity.postId,
    likes: entity.likes,
  );

  CommentEntity toEntity() => CommentEntity(
    id: id,
    text: text,
    postId: postId,
    author: author,
    creationDate: creationDate,
    parentCommentId: parentCommentId,
    status: status,
    replies: replies,
    likes: likes,
  );
}
