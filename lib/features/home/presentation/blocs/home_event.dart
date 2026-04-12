import 'dart:io';

import 'package:equatable/equatable.dart';
import '../../domain/entities/comments_entity.dart';
import '../../domain/entities/post_entity.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPostsEvent extends HomeEvent {}

class AddPostEvent extends HomeEvent {
  final PostEntity post;
  AddPostEvent(this.post);
  @override
  List<Object?> get props => [post];
}

class DeletePostEvent extends HomeEvent {
  final int id;
  DeletePostEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class FetchPostsCommentsEvent extends HomeEvent {
  final int postId;
  FetchPostsCommentsEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}

class AddCommentEvent extends HomeEvent {
  final CommentEntity comment;
  final int? creatorId;
  final int? initialCount;
  AddCommentEvent(this.comment, {this.creatorId, this.initialCount});
  @override
  List<Object?> get props => [comment, creatorId, initialCount];
}

class FetchPostsLikesEvent extends HomeEvent {
  final int postId;
  FetchPostsLikesEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}

class AddLikeEvent extends HomeEvent {
  final int postId;
  final int? creatorId;
  AddLikeEvent(this.postId, {this.creatorId});
  @override
  List<Object?> get props => [postId, creatorId];
}
class GetPostCommentsCountsEvent extends HomeEvent {
  final int postId;
  GetPostCommentsCountsEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}
class DeleteLikeEvent extends HomeEvent {
  final int postId;
  DeleteLikeEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}
class ClearPostDetailsEvent extends HomeEvent {}
class PickImageEvent extends HomeEvent {}
class SubmitPostEvent extends HomeEvent {}
class PickImagesFromGalleryEvent extends HomeEvent {}
class AddImageFromCameraEvent extends HomeEvent {
  final File image;
  AddImageFromCameraEvent(this.image);
  @override
  List<Object?> get props => [image];
}

class RemoveSelectedImageEvent extends HomeEvent {
  final int index;
  RemoveSelectedImageEvent(this.index);
  @override
  List<Object?> get props => [index];
}
class AddReplyEvent extends HomeEvent {
  final CommentEntity reply;
  final int parentCommentId;
  final int? creatorId;
  final int? initialCount;
  AddReplyEvent(this.reply, this.parentCommentId, {this.creatorId, this.initialCount});
  @override
  List<Object?> get props => [reply, parentCommentId, creatorId, initialCount];
}
class SetReplyingToEvent extends HomeEvent {
  final CommentEntity? comment;
  SetReplyingToEvent(this.comment);
}
class ToggleCommentRepliesEvent extends HomeEvent {
  final int commentId;
   ToggleCommentRepliesEvent(this.commentId);
  @override
  List<Object?> get props => [commentId];
}
class RefreshCommentsSilentlyEvent extends HomeEvent {
  final int postId;
  RefreshCommentsSilentlyEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}
class UpdatePostCommentsCountEvent extends HomeEvent {
  final int postId;
  UpdatePostCommentsCountEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}
class AddCommentLikeEvent extends HomeEvent{
  final int commentId;
  final int? creatorId;
  AddCommentLikeEvent(this.commentId, {this.creatorId});
  @override
  List<Object?> get props => [commentId, creatorId];
}
class GetCommentsLikeEvent extends HomeEvent{
  final int commentId;
  GetCommentsLikeEvent(this.commentId);
  @override
  List<Object?> get props => [commentId];
}
class UnLikeCommentEvent extends HomeEvent{
  final int commentId;
  UnLikeCommentEvent(this.commentId);
  @override
  List<Object?> get props => [commentId];
}
class ReportPostEvent extends HomeEvent{
  final int postId;
  final int reasonId;
  final String reason;
  ReportPostEvent(this.postId, this.reasonId, this.reason);
  @override
  List<Object?> get props => [postId, reasonId, reason];
}
class GetReportReasonsEvent extends HomeEvent{}
class GetReportedPostsEvent extends HomeEvent{
  final int postId;
  GetReportedPostsEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}
class SavePostEvent extends HomeEvent{
  final int postId;
  SavePostEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}
class UnSavePostEvent extends HomeEvent{
  final int postId;
  UnSavePostEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}

class LoadMorePostsEvent extends HomeEvent {}