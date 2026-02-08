import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/entities/register_domain_entity.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/data/models/comments_like_model.dart';
import 'package:pettix/features/home/data/models/comments_model.dart';
import 'package:pettix/features/home/data/models/likes_model.dart';
import 'package:pettix/features/home/data/models/post_model.dart';
import 'package:pettix/features/home/data/sources/local/local_data_source.dart';
import 'package:pettix/features/home/data/sources/remote/home_remote_data_source.dart';
import 'package:pettix/features/home/domain/entities/author_entity.dart';
import 'package:pettix/features/home/domain/entities/comment_like_entity.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/domain/entities/likes_entity.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/domain/entities/report_entity.dart';
import 'package:pettix/features/home/domain/entities/report_reason_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@Injectable(as: HomeDomainRepository)
class HomeRepositoryImpl implements HomeDomainRepository {
  final RemoteDataSource remoteDataSource;
  final GetUserLocalDataSource homeLocalDataSource;

  HomeRepositoryImpl(this.remoteDataSource, this.homeLocalDataSource);

  /// Posts

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    final result = await remoteDataSource.getPosts();

    return result.fold(
          (failure) => Left(failure),
          (models) =>
          Right(
            models
                .map(
                  (model) =>
                  model.toEntity(
                    PostModel(
                      id: model.id,
                      author: model.author,
                      comments: model.comments,
                      likes: model.likes,
                      content: model.content,
                      creationDate: model.creationDate,
                      modifyDate: model.modifyDate,
                      images: model.images,
                    ),
                  ),
            )
                .toList(),
          ),
    );
  }

  @override
  Future<Either<Failure, void>> addPost(PostEntity post) async {
    final postModel = PostModel.fromEntity(post);
    return remoteDataSource.addPost(postModel);
  }

  @override
  Future<Either<Failure, void>> deletePost(int id) async {
    return remoteDataSource.deletePost(id);
  }

  @override
  Future<Either<Failure, void>> editPost(PostEntity post) async {
    final postModel = PostModel.fromEntity(post);
    return remoteDataSource.editPost(postModel);
  }

  /// Comments

  @override
  Future<Either<Failure, List<CommentEntity>>> getPostComments(
      int postId,) async {
    final result = await remoteDataSource.getPostComments(postId);

    return result.fold(
          (failure) => Left(failure),
          (models) =>
          Right(
            models
                .map(
                  (model) =>
                  model.toEntity(
                    CommentModel(
                      id: model.id,
                      text: model.text,
                      author: model.author,
                      creationDate: model.creationDate,
                      postId: model.postId,
                      parentCommentId: model.parentCommentId,
                      replies: model.replies,
                      likes: model.likes,
                    ),
                  ),
            )
                .toList(),
          ),
    );
  }

  @override
  Future<Either<Failure, void>> addComment(CommentEntity comment,
      int postId,
      int? parentCommentId,) async {
    final commentModel = CommentModel.fromEntity(comment);
    return remoteDataSource.addComment(commentModel, postId, parentCommentId);
  }

  @override
  Future<Either<Failure, void>> deleteComment(int id) async {
    return remoteDataSource.deleteComment(id);
  }

  @override
  Future<Either<Failure, void>> editComment(CommentEntity comment) async {
    final commentModel = CommentModel.fromEntity(comment);
    return remoteDataSource.editComment(commentModel);
  }

  /// Likes

  @override
  Future<Either<Failure, List<LikesEntity>>> getPostLikes(int postId) async {
    final result = await remoteDataSource.getPostLikes(postId);

    return result.fold(
          (failure) => Left(failure),
          (likes) =>
          Right(
            likes
                .map(
                  (like) =>
                  like.toEntity(
                    LikesModel(
                      id: like.id,
                      author: like.author,
                      creationDate: like.creationDate,
                      postId: like.postId,
                    ),
                  ),
            )
                .toList(),
          ),
    );
  }

  @override
  Future<Either<Failure, LikesEntity>> likePost(int postId, int userId) async {
    final result = await remoteDataSource.likePost(postId, userId);

    return result.fold((failure) => Left(failure), (success) {
      return Right(
        LikesModel(
          id: 0,
          author: AuthorModel(
            id: userId,
            nameAr: '',
            nameEn: '',
            avatar: '',
            email: null,
            phone: null,
            genderId: null,
            genderName: null,
            contactTypeId: 4,
            statusId: 1,
            age: null,
          ),
          postId: 0,
          creationDate: DateTime.now().toIso8601String(),
        ),
      );
    });
  }

  @override
  Future<Either<Failure, void>> unlikePost(int postId) async {
    final result = await remoteDataSource.unlikePost(postId);
    return result.fold((failure) => Left(failure), (success) => Right(null));
  }

  @override
  Future<Either<Failure, UserEntity>> getCachedUserData() async {
    try {
      return Right(homeLocalDataSource.getUserData());
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, int>> getPostCommentsCount(int postId) async {
    try {
      final result = await remoteDataSource.getPostCommentsCount(postId);
      return result.fold(
            (failure) => Left(failure),
            (success) => Right(success),
      );
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<CommentLikeEntity>>> getCommentLikesCount(
      int postId,) async {
    final result = await remoteDataSource.getCommentsLikesCount(postId);
    return result.fold(
          (failure) => Left(failure),
          (models) =>
          Right(
            models
                .map(
                  (model) =>
                  model.toEntity(
                    CommentsLikeModel(
                      id: model.id,
                      commentId: model.commentId,
                      author: model.author,
                      creationDate: model.creationDate,
                    ),
                  ),
            )
                .toList(),
          ),
    );
  }

  @override
  Future<Either<Failure, CommentLikeEntity>> likeComment(int commentId) async {
    final result = await remoteDataSource.likeComment(commentId);
    return result.fold((failure) => Left(failure), (success) {
      return Right(
        CommentsLikeModel(
          id: 0,
          commentId: 0,
          author: AuthorModel(
            id: 0,
            nameAr: '',
            nameEn: '',
            avatar: '',
            email: null,
            phone: null,
            genderId: null,
            genderName: null,
            contactTypeId: 4,
            statusId: 1,
            age: null,
          ),
          creationDate: DateTime.now().toIso8601String(),
        ),
      );
    });
  }

  @override
  Future<Either<Failure, void>> unlikeComment(int commentId) async {
    final result = await remoteDataSource.unlikeComment(commentId);
    return result.fold((failure) => Left(failure), (success) => Right(null));
  }

  @override
  Future<Either<Failure, void>> reportPost(int postId,
      int reasonId,
      String reason,) async {
    final result = await remoteDataSource.reportPost(postId, reasonId, reason);
    return result.fold((failure) => Left(failure), (success) => Right(null));
  }

  @override
  Future<Either<Failure, List<ReportReasonEntity>>> getReportReasons() async {
    final result = await remoteDataSource.getReportReasons();
    return result.fold(
          (failure) => Left(failure),
          (success) =>
          Right(
            success
                .map(
                  (reason) =>
                  ReportReasonEntity(id: reason['id'], name: reason['name']),
            )
                .toList(),
          ),
    );
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> reportedPosts(int postId) async {
    final result = await remoteDataSource.reportedPosts(postId);
    return result.fold(
          (failure) => Left(failure),
          (success) =>
          Right(
            success
                .map(
                  (report) =>
                  ReportEntity(
                    id: report['id'],
                    postId: report['postId'],
                    author: report['author'],
                    reasonName: report['reasonName'],
                    customReason: report['customReason'],
                    creationDate: DateTime.parse(report['creationDate']),
                  ),
            )
                .toList(),
          ),
    );
  }
}
