import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:pettix/features/home/domain/entities/comment_like_entity.dart';
import 'package:pettix/features/home/domain/entities/report_entity.dart';
import 'package:pettix/features/home/domain/entities/report_reason_entity.dart';
import '../../domain/entities/comments_entity.dart';
import '../../domain/entities/likes_entity.dart';
import '../../domain/entities/post_entity.dart';

// Sentinel used by copyWith to allow explicitly passing `null` for nullable fields
const _copyWithSentinel = Object();

class HomeState extends Equatable {
  final List<PostEntity> posts;
  final List<CommentEntity> comments;
  final List<LikesEntity> likes;
  final List<CommentLikeEntity> commentLikes;
  final List<int> likedCommentId;
  final List<int> likedPostIds;
  final List<int> savedPostIds;
  final Map<int, int> commentLikesCount;
  final Map<int, int> postLikesCount;
  final Map<int, int> postCommentsCount;
  final bool isPostsLoading;
  final bool isMorePostsLoading;
  final bool isAddPostLoading;
  final bool isCommentsLoading;
  final bool isLikesLoading;
  final bool isPostAdded;
  final bool isUploadingPost;
  final bool isPostUploadSuccess;
  final bool isPostUploadError;
  final String? error;
  final int pageIndex;
  final int totalCount;
  final List<File> selectedImages;
  final CommentEntity? replyingTo;
  final Map<int, bool> expandedComments;
  final List<ReportReasonEntity> reportReasons;
  final List<ReportEntity> reports;
  final bool isReportLoading;
  final int postId;
  final bool isSaved;
  const HomeState({
    this.posts = const [],
    this.comments = const [],
    this.likes = const [],
    this.likedCommentId = const [],
    this.likedPostIds = const [],
    this.savedPostIds = const [],
    this.postLikesCount = const {},
    this.postCommentsCount = const {},
    this.isPostsLoading = false,
    this.isMorePostsLoading = false,
    this.isAddPostLoading = false,
    this.isCommentsLoading = false,
    this.isLikesLoading = false,
    this.isPostAdded = false,
    this.isUploadingPost = false,
    this.isPostUploadSuccess = false,
    this.isPostUploadError = false,
    this.error,
    this.pageIndex = 1,
    this.totalCount = 0,
    this.selectedImages = const [],
    this.replyingTo,
    this.expandedComments = const {},
    this.commentLikes = const [],
    this.commentLikesCount = const {},
    this.reportReasons = const [],
    this.reports = const [],
    this.isReportLoading = false,
    this.postId = 0,
    this.isSaved = false,
  });

  HomeState copyWith({
    List<PostEntity>? posts,
    List<CommentEntity>? comments,
    List<LikesEntity>? likes,
    List<int>? likedPostIds,
    List<int>? savedPostIds,
    Map<int, int>? postLikesCount,
    Map<int, int>? postCommentsCount,
    bool? isPostsLoading,
    bool? isMorePostsLoading,
    bool? isAddPostLoading,
    bool? isCommentsLoading,
    bool? isLikesLoading,
    bool? isPostAdded,
    bool? isUploadingPost,
    bool? isPostUploadSuccess,
    bool? isPostUploadError,
    String? error,
    int? pageIndex,
    int? totalCount,
    List<File>? selectedImages,
    // Use Object? with a sentinel so callers can explicitly pass null to clear the field
    Object? replyingTo = _copyWithSentinel,
    Map<int, bool>? expandedComments,
    List<CommentLikeEntity>? commentLikes,
    List<int>? likedCommentId,
    Map<int, int>? commentLikesCount,
    List<ReportReasonEntity>? reportReasons,
    List<ReportEntity>? reports,
    bool? isReportLoading,
    int? postId,
    bool? isSaved
  }) {
    return HomeState(
      posts: posts ?? this.posts,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      likedPostIds: likedPostIds ?? this.likedPostIds,
      savedPostIds: savedPostIds ?? this.savedPostIds,
      postLikesCount: postLikesCount ?? this.postLikesCount,
      postCommentsCount: postCommentsCount ?? this.postCommentsCount,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      isMorePostsLoading: isMorePostsLoading ?? this.isMorePostsLoading,
      isAddPostLoading: isAddPostLoading ?? this.isAddPostLoading,
      isCommentsLoading: isCommentsLoading ?? this.isCommentsLoading,
      isLikesLoading: isLikesLoading ?? this.isLikesLoading,
      isPostAdded: isPostAdded ?? this.isPostAdded,
      isUploadingPost: isUploadingPost ?? this.isUploadingPost,
      isPostUploadSuccess: isPostUploadSuccess ?? this.isPostUploadSuccess,
      isPostUploadError: isPostUploadError ?? this.isPostUploadError,
      error: error,
      pageIndex: pageIndex ?? this.pageIndex,
      totalCount: totalCount ?? this.totalCount,
      selectedImages: selectedImages ?? this.selectedImages,
      // If the caller did not pass a value, keep current. If they passed null explicitly, set to null.
      replyingTo: replyingTo == _copyWithSentinel ? this.replyingTo : (replyingTo as CommentEntity?),
      expandedComments: expandedComments ?? this.expandedComments,
      commentLikes: commentLikes ?? this.commentLikes,
      likedCommentId: likedCommentId ?? this.likedCommentId,
      commentLikesCount: commentLikesCount ?? this.commentLikesCount,
      reportReasons: reportReasons ?? this.reportReasons,
      reports: reports ?? this.reports,
      isReportLoading: isReportLoading ?? this.isReportLoading,
        postId: postId ?? this.postId,
        isSaved: isSaved ?? this.isSaved
    );
  }

  @override
  List<Object?> get props => [
    posts,
    comments,
    likes,
    likedPostIds,
    savedPostIds,
    postLikesCount,
    postCommentsCount,
    isPostsLoading,
    isMorePostsLoading,
    isAddPostLoading,
    isCommentsLoading,
    isLikesLoading,
    isPostAdded,
    isUploadingPost,
    isPostUploadSuccess,
    isPostUploadError,
    error,
    pageIndex,
    totalCount,
    selectedImages,
    replyingTo,
    expandedComments,
    commentLikes,
    likedCommentId,
    commentLikesCount,
    reportReasons,
    reports,
    isReportLoading,
    postId,
    isSaved
  ];
}
