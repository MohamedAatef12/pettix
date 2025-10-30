import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/entities/register_domain_entity.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/domain/entities/likes_entity.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';



abstract class HomeDomainRepository {
  // Posts
  Future<Either<Failure, List<PostEntity>>> getPosts();
  Future<Either<Failure, void>> addPost(PostEntity post);
  Future<Either<Failure, void>> deletePost(int id);
  Future<Either<Failure, void>> editPost(PostEntity post);
  Future<Either<Failure,int>> getPostCommentsCount(int postId);
  // Comments
  Future<Either<Failure, List<CommentEntity>>> getPostComments(int id);
  Future<Either<Failure, void>> addComment(CommentEntity comment,int postId, int? parentCommentId,);
  Future<Either<Failure, void>> deleteComment(int id);
  Future<Either<Failure, void>> editComment(CommentEntity comment);

  // Likes
  Future<Either<Failure, List<LikesEntity>>> getPostLikes(int postId);
  Future<Either<Failure, LikesEntity>> likePost(int postId, int id);
  Future<Either<Failure, void>> unlikePost(int postId);
  // Cached Data
  Future<Either<Failure, UserEntity>> getCachedUserData();
}
