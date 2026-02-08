import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/domain/entities/comment_like_entity.dart';

class CommentsLikeModel extends CommentLikeEntity{
  const CommentsLikeModel({
    required super.id,
    required super.commentId,
    required super.author,
    required super.creationDate,
  });
  factory CommentsLikeModel.fromJson(Map<String, dynamic> json) {
    return CommentsLikeModel(
      id: json['id'] as int,
      commentId: json['commentId'] as int,
      creationDate: json['creationDate'] ?? '',
      author: AuthorModel.fromJson(json['author']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commentId': commentId,
      'author': (author as AuthorModel).toJson(),
      'creationDate': creationDate,
    };
  }
  CommentsLikeModel.fromEntity(CommentLikeEntity entity)
      : super(
    id: entity.id,
    commentId: entity.commentId,
    author: entity.author,
    creationDate: entity.creationDate,
  );
  CommentLikeEntity toEntity(CommentsLikeModel model) => CommentLikeEntity(
    id: model.id,
    commentId: model.commentId,
  author: model.author,
    creationDate: model.creationDate,
  );
}