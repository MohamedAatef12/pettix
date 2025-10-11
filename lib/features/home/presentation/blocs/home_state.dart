import 'package:equatable/equatable.dart';

import '../../domain/entities/comments_entity.dart';
import '../../domain/entities/likes_entity.dart';
import '../../domain/entities/post_entity.dart';

class HomeState extends Equatable {
  final List<PostEntity> posts;
  final List<CommentEntity> comments;
  final List<LikesEntity> likes;
  final Set<int> likedPostIds;
  final Map<int, int> postLikesCount;
  final Map<int, int> postCommentsCount;
  final bool isPostsLoading;
  final bool isCommentsLoading;
  final bool isLikesLoading;
  final bool isAddPostLoading;
  final bool isPostAdded;
  final bool isPostLiked;
  final String? error;

  const HomeState({
    this.posts = const [],
    this.comments = const [],
    this.likes = const [],
    this.likedPostIds = const {},
    this.postLikesCount = const {},
    this.postCommentsCount = const {},
    this.isPostsLoading = false,
    this.isCommentsLoading = false,
    this.isLikesLoading = false,
    this.isAddPostLoading = false,
    this.isPostAdded = false,
    this.isPostLiked = false,
    this.error,
  });

  HomeState copyWith({
    List<PostEntity>? posts,
    List<CommentEntity>? comments,
    List<LikesEntity>? likes,
    Set<int>? likedPostIds,
    Map<int, int>? postLikesCount,
    Map<int, int>? postCommentsCount,
    bool? isPostsLoading,
    bool? isCommentsLoading,
    bool? isLikesLoading,
    bool? isAddPostLoading,
    bool? isPostAdded,
    bool? isPostLiked,
    String? error,
  }) {
    return HomeState(
      posts: posts ?? this.posts,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      likedPostIds: likedPostIds ?? this.likedPostIds,
      postLikesCount: postLikesCount ?? this.postLikesCount,
      postCommentsCount: postCommentsCount ?? this.postCommentsCount,
      isLikesLoading: isLikesLoading ?? this.isLikesLoading,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      isCommentsLoading: isCommentsLoading ?? this.isCommentsLoading,
      isAddPostLoading: isAddPostLoading ?? this.isAddPostLoading,
      isPostAdded: isPostAdded ?? this.isPostAdded,
      isPostLiked: isPostLiked ?? this.isPostLiked,
      error: error,
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
    isCommentsLoading,
    isLikesLoading,
    isAddPostLoading,
    isPostAdded,
    isPostLiked,
    error,
  ];
}
