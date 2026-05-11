import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/api_services.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/data/models/comments_like_model.dart';
import 'package:pettix/features/home/data/models/comments_model.dart';
import 'package:pettix/features/home/data/models/likes_model.dart';
import 'package:pettix/features/home/data/models/paginated_posts_model.dart';
import 'package:pettix/features/home/data/models/post_model.dart';
import 'home_remote_data_source.dart';

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiService apiService;

  RemoteDataSourceImpl(this.apiService);

  // Posts

  @override
  Future<Either<Failure, PaginatedPostsModel>> getPosts({
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await apiService.getList(
        endPoint: Constants.postsEndpoint,
        queryParameters: {'pageIndex': pageIndex, 'pageSize': pageSize},
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }

      final resultData = response.result as Map<String, dynamic>? ?? {};
      if (resultData['data'] != null &&
          (resultData['data'] as List).isNotEmpty) {
        print(
          '🔍 [DEBUG] First Post JSON keys: ${(resultData['data'] as List).first.keys.toList()}',
        );
        print(
          '🔍 [DEBUG] First Post JSON: ${(resultData['data'] as List).first}',
        );
      }
      return Right(PaginatedPostsModel.fromJson(resultData));
    } catch (e) {
      log('Error fetching posts: $e');
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getUserPosts() async {
    try {
      final response = await apiService.getList(
        endPoint: Constants.userPostsEndpoint,
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }

      final data = response.result as List? ?? [];
      final posts =
          data
              .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
              .toList();
      return Right(posts);
    } catch (e) {
      log('Error fetching user posts: $e');
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getSavedPosts() async {
    try {
      final response = await apiService.getList(
        endPoint: Constants.mySavedPostsEndpoint,
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }

      final data = response.result as List? ?? [];
      final posts =
          data
              .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
              .toList();
      return Right(posts);
    } catch (e) {
      log('Error fetching saved posts: $e');
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, PostModel>> getPostById(int id) async {
    try {
      final response = await apiService.get(
        endPoint: '${Constants.getPostByIdEndpoint}/$id',
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }

      final resultData = response.result as Map<String, dynamic>? ?? {};
      return Right(PostModel.fromJson(resultData));
    } catch (e) {
      log('Error fetching post: $e');
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> editPost(PostModel post) async {
    try {
      final jsonData = await post.toJson();
      final response = await apiService.put(
        endPoint: '${Constants.postsEndpoint}/${post.id}',
        data: jsonData,
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> addPost(PostModel post) async {
    try {
      final jsonData = await post.toJson();
      final response = await apiService.post(
        endPoint: Constants.addPostsEndpoint,
        data: jsonData,
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }

      return const Right(null);
    } catch (e) {
      log('Error adding post: $e');
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(int id) async {
    try {
      final response = await apiService.delete(
        endPoint: '${Constants.postsEndpoint}/$id',
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  // Comments

  @override
  Future<Either<Failure, List<CommentModel>>> getPostComments(
    int postId,
  ) async {
    try {
      final response = await apiService.getList(
        endPoint: '${Constants.commentsEndpoint}/$postId',
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }

      final data = response.result as List? ?? [];
      final comments = data.map((e) => CommentModel.fromJson(e)).toList();
      // Sort comments by date descending (latest first)
      comments.sort(
        (a, b) => DateTime.parse(
          b.creationDate,
        ).compareTo(DateTime.parse(a.creationDate)),
      );

      if (comments.isEmpty) {
        return const Right([]);
      }

      return Right(comments);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> addComment(
    CommentModel comment,
    int postId,
    int? parentCommentId,
  ) async {
    try {
      final response = await apiService.post(
        endPoint: '${Constants.addCommentEndpoint}/$postId',
        data: comment.toJson(),
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }

      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(int id) async {
    try {
      final response = await apiService.delete(
        endPoint: '${Constants.commentsEndpoint}/$id',
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> editComment(CommentModel comment) async {
    try {
      final response = await apiService.put(
        endPoint: '${Constants.commentsEndpoint}/${comment.id}',
        data: comment.toJson(),
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  // Likes

  @override
  Future<Either<Failure, List<LikesModel>>> getPostLikes(int postId) async {
    try {
      final response = await apiService.getList(
        endPoint: '${Constants.getPostLikes}/$postId',
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }

      final data = response.result as List? ?? [];
      final likes = data.map((e) => LikesModel.fromJson(e)).toList();
      // Sort likes by date descending (latest first)
      likes.sort(
        (a, b) => DateTime.parse(
          b.creationDate,
        ).compareTo(DateTime.parse(a.creationDate)),
      );
      if (likes.isEmpty) {
        return const Right([]);
      }

      return Right(likes);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, LikesModel>> likePost(int postId, int userId) async {
    try {
      final response = await apiService.post(
        endPoint: '${Constants.postLikesEndpoint}/$postId',
        data: {'userId': userId, 'date': DateTime.now().toIso8601String()},
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      return Right(
        LikesModel.fromJson(response.result as Map<String, dynamic>? ?? {}),
      );
    } on DioException catch (dioError) {
      return Left(DioFailure.fromDioError(dioError));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> unlikePost(int postId) async {
    try {
      final rawResponse = await apiService.delete(
        endPoint: '${Constants.postUnLikesEndpoint}/$postId',
      );
      print(
        '🚀 [API RESPONSE FOR UNLIKE] success=${rawResponse.success}, message="${rawResponse.message}", result=${rawResponse.result}',
      );
      if (!rawResponse.success) {
        return Left(Failure(rawResponse.message));
      }
      return const Right(null);
    } on DioException catch (dioError) {
      return Left(DioFailure.fromDioError(dioError));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> getPostCommentsCount(int postId) async {
    try {
      final response = await apiService.get(
        endPoint: '${Constants.postCommentsCount}/$postId/count',
      );

      if (!response.success) {
        return Left(Failure(response.message));
      }

      final result = response.result as Map<String, dynamic>? ?? {};
      final count = result['commentsCount'] ?? 0; // ✅ استخدم المفتاح الصحيح
      return Right(count);
    } on DioException catch (dioError) {
      return Left(DioFailure.fromDioError(dioError));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CommentsLikeModel>>> getCommentsLikesCount(
    int commentId,
  ) async {
    try {
      final response = await apiService.getList(
        endPoint: '${Constants.commentLikesCountEndpoint}/$commentId/count',
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }

      final data = response.result as List? ?? [];
      final commentsLikes =
          data.map((e) => CommentsLikeModel.fromJson(e)).toList();
      // Sort commentsLikes by date descending (latest first)
      commentsLikes.sort(
        (a, b) => DateTime.parse(
          b.creationDate,
        ).compareTo(DateTime.parse(a.creationDate)),
      );
      if (commentsLikes.isEmpty) {
        return const Right([]);
      }

      return Right(commentsLikes);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> likeComment(int commentId) async {
    try {
      final response = await apiService.post(
        endPoint: '${Constants.likeCommentEndpoint}/$commentId',
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      return const Right(null);
    } on DioException catch (dioError) {
      return Left(DioFailure.fromDioError(dioError));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> unlikeComment(int commentId) async {
    try {
      final response = await apiService.delete(
        endPoint: '${Constants.unlikeCommentEndpoint}/$commentId',
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      return const Right(null);
    } on DioException catch (dioError) {
      return Left(DioFailure.fromDioError(dioError));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> reportPost(
    int postId,
    int reasonId,
    String reason,
  ) async {
    try {
      final response = await apiService.post(
        endPoint: Constants.addReportPostEndpoint,
        data: {'postId': postId, 'reasonId': reasonId, 'customReason': reason},
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getReportReasons() async {
    try {
      final response = await apiService.getList(
        endPoint: Constants.reportReasonsEndpoint,
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      final data = response.result as List? ?? [];
      return Right(data);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> reportedPosts(int postId) async {
    try {
      final response = await apiService.getList(
        endPoint: '${Constants.reportedPostsEndpoint}/$postId',
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      final data = response.result as List? ?? [];
      return Right(data);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> savePost(int postId) async {
    try {
      final response = await apiService.post(
        endPoint: '${Constants.savePostEndpoint}/$postId/save',
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> unSavePost(int postId) async {
    try {
      final response = await apiService.delete(
        endPoint: '${Constants.unSavePostEndpoint}/$postId/unsave',
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }
}
