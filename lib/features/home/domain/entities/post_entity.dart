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
  final bool isLiked;
  final int totalComments;
  final int totalLikes;
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
    this.isLiked = false,
    this.totalComments = 0,
    this.totalLikes = 0,
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
    isLiked,
    totalComments,
    totalLikes,
  ];

  PostEntity copyWith({
    int? id,
    String? content,
    String? creationDate,
    String? modifyDate,
    AuthorEntity? author,
    List<CommentEntity>? comments,
    List<LikesEntity>? likes,
    List<String>? images,
    int? statusId,
    bool? isSaved,
    bool? isLiked,
    int? totalComments,
    int? totalLikes,
  }) {
    return PostEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      creationDate: creationDate ?? this.creationDate,
      modifyDate: modifyDate ?? this.modifyDate,
      author: author ?? this.author,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      images: images ?? this.images,
      statusId: statusId ?? this.statusId,
      isSaved: isSaved ?? this.isSaved,
      isLiked: isLiked ?? this.isLiked,
      totalComments: totalComments ?? this.totalComments,
      totalLikes: totalLikes ?? this.totalLikes,
    );
  }
}

