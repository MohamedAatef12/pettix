import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/comments_entity.dart';
import '../../domain/entities/likes_entity.dart';
import '../../domain/entities/post_entity.dart';

class HomeState extends Equatable {
  final List<PostEntity> posts;
  final List<CommentEntity> comments;
  final List<LikesEntity> likes;
  final List<int> likedPostIds;
  final Map<int, int> postLikesCount;
  final Map<int, int> postCommentsCount;
  final bool isPostsLoading;
  final bool isAddPostLoading;
  final bool isCommentsLoading;
  final bool isLikesLoading;
  final bool isPostAdded;
  final String? error;
  final List<File> selectedImages;
  const HomeState({
    this.posts = const [],
    this.comments = const [],
    this.likes = const [],
    this.likedPostIds = const [],
    this.postLikesCount = const {},
    this.postCommentsCount = const {},
    this.isPostsLoading = false,
    this.isAddPostLoading = false,
    this.isCommentsLoading = false,
    this.isLikesLoading = false,
    this.isPostAdded = false,
    this.error,
    this.selectedImages = const [],
  });

  HomeState copyWith({
    List<PostEntity>? posts,
    List<CommentEntity>? comments,
    List<LikesEntity>? likes,
    List<int>? likedPostIds,
    Map<int, int>? postLikesCount,
    Map<int, int>? postCommentsCount,
    bool? isPostsLoading,
    bool? isAddPostLoading,
    bool? isCommentsLoading,
    bool? isLikesLoading,
    bool? isPostAdded,
    String? error,
    List<File>? selectedImages,
  }) {
    return HomeState(
      posts: posts ?? this.posts,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      likedPostIds: likedPostIds ?? this.likedPostIds,
      postLikesCount: postLikesCount ?? this.postLikesCount,
      postCommentsCount: postCommentsCount ?? this.postCommentsCount,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      isAddPostLoading: isAddPostLoading ?? this.isAddPostLoading,
      isCommentsLoading: isCommentsLoading ?? this.isCommentsLoading,
      isLikesLoading: isLikesLoading ?? this.isLikesLoading,
      isPostAdded: isPostAdded ?? this.isPostAdded,
      error: error,
      selectedImages: selectedImages ?? this.selectedImages,
    );
  }

  @override
  List<Object?> get props => [
    posts,
    comments,
    likes,
    likedPostIds,
    postLikesCount,
    postCommentsCount,
    isPostsLoading,
    isAddPostLoading,
    isCommentsLoading,
    isLikesLoading,
    isPostAdded,
    error,
    selectedImages,
  ];
}
