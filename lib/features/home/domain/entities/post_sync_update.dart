enum PostSyncUpdateType { like, unlike, save, unsave, addComment, deletePost }

class PostSyncUpdate {
  final int postId;
  final PostSyncUpdateType type;
  final dynamic value; // Optional payload (e.g., new comment count, user id, etc.)

  PostSyncUpdate({
    required this.postId,
    required this.type,
    this.value,
  });
}
