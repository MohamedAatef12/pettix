import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/data/models/comments_like_model.dart';
import '../../models/paginated_posts_model.dart';

import '../../models/comments_model.dart';
import '../../models/likes_model.dart';
import '../../models/post_model.dart';

abstract class RemoteDataSource {
  // Posts
  Future<Either<Failure, PaginatedPostsModel>> getPosts({int pageIndex = 1, int pageSize = 10});
  Future<Either<Failure, void>> addPost(PostModel post);
  Future<Either<Failure, void>> deletePost(int id);
  Future<Either<Failure, void>> editPost(PostModel post);
  Future<Either<Failure,int>> getPostCommentsCount(int postId);
  // Comments
  Future<Either<Failure, List<CommentModel>>> getPostComments(int id);
  Future<Either<Failure, void>> addComment(
    CommentModel comment,
    int postId,
    int? parentCommentId,
  );
  Future<Either<Failure, void>> deleteComment(int id);
  Future<Either<Failure, void>> editComment(CommentModel comment);

  // Likes
  Future<Either<Failure, List<LikesModel>>> getPostLikes(int postId);
  Future<Either<Failure, void>> likePost(int postId, int userId);
  Future<Either<Failure, void>> unlikePost(int postId);
  Future<Either<Failure,List<CommentsLikeModel>>>getCommentsLikesCount(int commentId);
  Future<Either<Failure, void>> likeComment(int commentId);
  Future<Either<Failure, void>> unlikeComment(int commentId);
// reports
  Future<Either<Failure, void>> reportPost(int postId, int reasonId, String reason);
  Future<Either<Failure, List<dynamic>>> getReportReasons();
  Future<Either<Failure, List<dynamic>>> reportedPosts(int postId);
// saved posts
  Future<Either<Failure, void>> savePost(int postId);
  Future<Either<Failure, void>> unSavePost(int postId);
}
