import 'package:equatable/equatable.dart';
import 'package:pettix/features/home/domain/entities/author_entity.dart';

class CommentLikeEntity extends Equatable {
  final int id;
  final int commentId;
  final String? commentText;
  final AuthorEntity author;
  final String creationDate;

  const CommentLikeEntity({
    required this.id,
    required this.commentId,
    this.commentText,
    required this.author,
    required this.creationDate,
  });

  @override
  List<Object?> get props => [id, commentId, commentText, author, creationDate];
}