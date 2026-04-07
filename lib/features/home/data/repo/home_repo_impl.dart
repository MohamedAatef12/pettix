import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/data/models/comments_like_model.dart';
import 'package:pettix/features/home/data/models/comments_model.dart';
import 'package:pettix/features/home/data/models/likes_model.dart';
import 'package:pettix/features/home/data/models/post_model.dart';
import 'package:pettix/features/home/data/sources/local/local_data_source.dart';
import 'package:pettix/features/home/data/sources/remote/home_remote_data_source.dart';
import 'package:pettix/features/home/domain/entities/comment_like_entity.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/domain/entities/likes_entity.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/domain/entities/report_entity.dart';
import 'package:pettix/features/home/domain/entities/report_reason_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';
import 'package:pettix/features/notification/data/data_sources/notification_remote_data_source.dart';

import 'package:pettix/features/home/domain/entities/paginated_posts.dart';

@Injectable(as: HomeDomainRepository)
class HomeRepositoryImpl implements HomeDomainRepository {
  final RemoteDataSource remoteDataSource;
  final GetUserLocalDataSource homeLocalDataSource;
  final NotificationRemoteDataSource notificationRemoteDataSource;

  HomeRepositoryImpl(
    this.remoteDataSource,
    this.homeLocalDataSource,
    this.notificationRemoteDataSource,
  );

  /// Posts

  @override
  Future<Either<Failure, PaginatedPosts>> getPosts(
      {int pageIndex = 1, int pageSize = 10}) async {
    final result =
        await remoteDataSource.getPosts(pageIndex: pageIndex, pageSize: pageSize);

    return result.fold(
      (failure) => Left(failure),
      (model) => Right(
        PaginatedPosts(
          posts: model.postsModels.map((m) => m.toEntity()).toList(),
          pageIndex: model.pageIndex,
          pageSize: model.pageSize,
          totalCount: model.totalCount,
        ),
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
                  model.toEntity(),
            )
                .toList(),
          ),
    );
  }

  @override
  Future<Either<Failure, void>> addComment(
    CommentEntity comment,
    int postId,
    int? parentCommentId, {
    int? creatorId,
  }) async {
    final commentModel = CommentModel.fromEntity(comment);
    final result = await remoteDataSource.addComment(
      commentModel,
      postId,
      parentCommentId,
    );

    return result.fold(
      (failure) => Left(failure),
      (success) {
        if (creatorId != null) {
          final currentUser = homeLocalDataSource.getUserData();
          final isReply = parentCommentId != null;
          
          notificationRemoteDataSource.sendNotification(
            userId: creatorId,
            sentBy: currentUser.id,
            notificationTypeId: isReply ? 3 : 2, // 2 for comment, 3 for reply
            title: isReply ? "New Reply! 💬" : "New Comment! 💬",
            body: "${currentUser.userName} ${isReply ? 'replied to your comment' : 'commented on your post'}.",
          );
        }
        return const Right(null);
      },
    );
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
                  like.toEntity(),
            )
                .toList(),
          ),
    );
  }

  @override
  Future<Either<Failure, LikesEntity>> likePost(
    int postId,
    int userId, {
    int? creatorId,
  }) async {
    final result = await remoteDataSource.likePost(postId, userId);

    return result.fold(
      (failure) => Left(failure),
      (success) {
        if (creatorId != null) {
          final currentUser = homeLocalDataSource.getUserData();
          notificationRemoteDataSource.sendNotification(
            userId: creatorId,
            sentBy: currentUser.id,
            notificationTypeId: 1, // 1 for Like
            title: "New Like! ❤️",
            body: "${currentUser.userName} liked your post.",
          );
        }
        
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
      },
    );
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
                  model.toEntity(),
            )
                .toList(),
          ),
    );
  }

  @override
  Future<Either<Failure, CommentLikeEntity>> likeComment(
    int commentId, {
    int? creatorId,
  }) async {
    final result = await remoteDataSource.likeComment(commentId);
    return result.fold(
      (failure) => Left(failure),
      (success) {
        if (creatorId != null) {
          final currentUser = homeLocalDataSource.getUserData();
          notificationRemoteDataSource.sendNotification(
            userId: creatorId,
            sentBy: currentUser.id,
            notificationTypeId: 1, // 1 for Like
            title: "Comment Liked! ❤️",
            body: "${currentUser.userName} liked your comment.",
          );
        }
        
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
      },
    );
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
    try {
      final result = await remoteDataSource.getReportReasons();
      return result.fold(
            (failure) => Left(failure),
            (success) {
          try {
            final reasons = success
                .map((reason) {
              if (reason is Map<String, dynamic>) {
                return ReportReasonEntity(
                  id: reason['id'] as int,
                  name: reason['name'] as String,
                );
              }
              throw FormatException('Invalid reason format: $reason');
            })
                .toList();
            return Right(reasons);
          } catch (e) {
            return Left(Failure('Failed to parse report reasons: $e'));
          }
        },
      );
    } catch (e) {
      return Left(Failure('Error fetching report reasons: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> reportedPosts(int postId) async {
    try {
      final result = await remoteDataSource.reportedPosts(postId);
      return result.fold(
            (failure) => Left(failure),
            (success) {
          try {
            final reports = success
                .map((report) {
              if (report is Map<String, dynamic>) {
                return ReportEntity(
                  id: report['id'] as int,
                  postId: report['postId'] as int,
                  author: report['author'],
                  reasonName: report['reasonName'] as String,
                  customReason: (report['customReason'] ?? '') as String,
                  creationDate: DateTime.parse(report['creationDate'] as String),
                );
              }
              throw FormatException('Invalid report format: $report');
            })
                .toList();
            return Right(reports);
          } catch (e) {
            return Left(Failure('Failed to parse reported posts: $e'));
          }
        },
      );
    } catch (e) {
      return Left(Failure('Error fetching reported posts: $e'));
    }
  }
  @override
  Future<Either<Failure, void>> savePost(int postId) async {
    final result = await remoteDataSource.savePost(postId);
    return result.fold((failure) => Left(failure), (success) => Right(null));
  }
  @override
  Future<Either<Failure, void>> unSavePost(int postId) async {
    final result = await remoteDataSource.unSavePost(postId);
    return result.fold((failure) => Left(failure), (success) => Right(null));
  }
}
