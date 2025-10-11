import 'package:equatable/equatable.dart';

import '../../domain/entities/comments_entity.dart';
import '../../domain/entities/post_entity.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPostsEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

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

class EditPostEvent extends HomeEvent {
  final PostEntity post;
  EditPostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

class FetchCommentsEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class FetchPostsCommentsEvent extends HomeEvent {
  final int postId;
  FetchPostsCommentsEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class AddCommentEvent extends HomeEvent {
  final CommentEntity comment;
  AddCommentEvent(this.comment);

  @override
  List<Object?> get props => [comment];
}

class FetchCommentCountEvent extends HomeEvent {
  final int postId;
  FetchCommentCountEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class EditCommentEvent extends HomeEvent {
  final CommentEntity comment;
  EditCommentEvent(this.comment);

  @override
  List<Object?> get props => [comment];
}

class DeleteCommentEvent extends HomeEvent {
  final int id;
  DeleteCommentEvent(this.id);
}

class FetchPostsLikesEvent extends HomeEvent {
  final int postId;
  FetchPostsLikesEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class FetchLikesCountEvent extends HomeEvent {
  final int postId;
  FetchLikesCountEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}

class AddLikeEvent extends HomeEvent {
  final int postId;
  AddLikeEvent(this.postId);

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
