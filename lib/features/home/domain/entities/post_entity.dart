import 'package:equatable/equatable.dart';
import 'package:pettix/features/home/domain/entities/author_entity.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/domain/entities/likes_entity.dart';
import '../../data/models/author_model.dart';

class PostEntity extends Equatable {
  final int id;
  final String content;
  final String creationDate;
  final String? modifyDate;
  final AuthorEntity author;
  final List<CommentEntity> comments;
  final List<LikesEntity> likes;
  final List<String> images;
  final int statusId;
  final bool isSaved;
  final int totalComments;
  const PostEntity({
    required this.id,
    required this.content,
    required this.creationDate,
    this.modifyDate,
    required this.author,
    required this.comments,
    required this.likes,
    required this.images,
    required this.statusId,
    required this.isSaved,
    this.totalComments = 0,
  });

  @override
  List<Object?> get props => [
    id,
    author,
    content,
    creationDate,
    modifyDate,
    comments,
    likes,
    images,
    statusId,
    isSaved,
    totalComments,
  ];
}
