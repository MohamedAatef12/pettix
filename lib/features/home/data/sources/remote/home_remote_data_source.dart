import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';

import '../../models/comments_model.dart';
import '../../models/likes_model.dart';
import '../../models/post_model.dart';

abstract class RemoteDataSource {
  // Posts
  Future<Either<Failure, List<PostModel>>> getPosts();
  Future<Either<Failure, void>> addPost(PostModel post);
  Future<Either<Failure, void>> deletePost(int id);
  Future<Either<Failure, void>> editPost(PostModel post);

  // Comments
  Future<Either<Failure, List<CommentModel>>> getPostComments(int id);
  Future<Either<Failure, void>> addComment(CommentModel comment);
  Future<Either<Failure, void>> deleteComment(int id);
  Future<Either<Failure, void>> editComment(CommentModel comment);

  // Likes
  Future<Either<Failure, List<LikesModel>>> getPostLikes(int postId);
  Future<Either<Failure, void>> likePost(int postId, int userId);
  Future<Either<Failure, void>> unlikePost(int postId);
}
