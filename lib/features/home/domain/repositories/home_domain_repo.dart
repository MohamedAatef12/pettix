import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/entities/register_domain_entity.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/home/domain/entities/comment_like_entity.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/domain/entities/likes_entity.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/domain/entities/report_entity.dart';
import 'package:pettix/features/home/domain/entities/report_reason_entity.dart';



import 'package:pettix/features/home/domain/entities/paginated_posts.dart';

abstract class HomeDomainRepository {
  // Posts
  Future<Either<Failure, PaginatedPosts>> getPosts({int pageIndex = 1, int pageSize = 10});
  Future<Either<Failure, void>> addPost(PostEntity post);
  Future<Either<Failure, void>> deletePost(int id);
  Future<Either<Failure, void>> editPost(PostEntity post);
  Future<Either<Failure,int>> getPostCommentsCount(int postId);
  // Comments
  Future<Either<Failure, List<CommentEntity>>> getPostComments(int id);
  Future<Either<Failure, void>> addComment(
    CommentEntity comment,
    int postId,
    int? parentCommentId, {
    int? creatorId,
  });
  Future<Either<Failure, void>> deleteComment(int id);
  Future<Either<Failure, void>> editComment(CommentEntity comment);

  // Likes
  Future<Either<Failure, List<LikesEntity>>> getPostLikes(int postId);
  Future<Either<Failure, LikesEntity>> likePost(int postId, int id, {int? creatorId});
  Future<Either<Failure, void>> unlikePost(int postId);
  Future<Either<Failure, List<CommentLikeEntity>>> getCommentLikesCount(int postId);
  Future<Either<Failure, CommentLikeEntity>> likeComment(int commentId, {int? creatorId});
  Future<Either<Failure, void>> unlikeComment(int commentId);
  // Cached Data
  Future<Either<Failure, UserEntity>> getCachedUserData();
  // reports
Future<Either<Failure, void>> reportPost(int postId,int reasonId, String reason);
Future<Either<Failure,List<ReportReasonEntity>>> getReportReasons();
Future<Either<Failure, List<ReportEntity>>> reportedPosts(int postId);
// saved posts
Future<Either<Failure, void>> savePost(int postId);
Future<Either<Failure, void>> unSavePost(int postId);

}
