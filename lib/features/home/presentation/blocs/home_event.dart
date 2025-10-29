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
  AddCommentEvent(this.comment);
  @override
  List<Object?> get props => [comment];
}

class FetchPostsLikesEvent extends HomeEvent {
  final int postId;
  FetchPostsLikesEvent(this.postId);
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
