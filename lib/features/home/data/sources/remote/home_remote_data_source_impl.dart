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
import 'package:pettix/features/home/data/models/post_model.dart';
import 'home_remote_data_source.dart';

@Injectable(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiService apiService;

  RemoteDataSourceImpl(this.apiService);

  // Posts

  @override
  Future<Either<Failure, List<PostModel>>> getPosts() async {
    final userToken = await DI.find<ICacheManager>().getToken();
    try {
      final response = await apiService.getList(
        endPoint: Constants.postsEndpoint,
        headers: {'Authorization': 'Bearer $userToken'},
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }

      final data = response.result as List? ?? [];
      final posts = data.map((e) => PostModel.fromJson(e)).toList();
      // Sort posts by date descending (latest first)
      posts.sort(
        (a, b) => DateTime.parse(
          b.creationDate,
        ).compareTo(DateTime.parse(a.creationDate)),
      );

      return Right(posts);
    } catch (e) {
      log('Error fetching posts: $e');
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> editPost(PostModel post) async {
    try {
      final jsonData = await post.toJson(); // 👈 ضروري await هنا

      final response = await apiService.put(
        endPoint: '${Constants.postsEndpoint}/${post.id}',
        data: jsonData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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
      log('Adding post: ${post.id}');
      final jsonData = await post.toJson(); // مهم جداً await هنا

      final response = await apiService.post(
        endPoint: Constants.postsEndpoint,
        data: jsonData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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
      final response = await apiService.delete(endPoint: '${Constants.postsEndpoint}/$id');
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
    final userToken = await DI.find<ICacheManager>().getToken();
    try {
      final response = await apiService.post(
        endPoint: '${Constants.commentsEndpoint}/$postId',
        data: comment.toJson(),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
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
      final response = await apiService.delete(endPoint: '${Constants.commentsEndpoint}/$id');
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
      // ✅ Get token from cache
      final userToken = await DI.find<ICacheManager>().getToken();

      // ✅ Send token in headers, not body
      final response = await apiService.post(
        endPoint: '${Constants.postLikesEndpoint}/$postId',
        data: {'userId': userId, 'date': DateTime.now().toIso8601String()},
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );
      if (!response.success) {
        return Left(Failure(response.message));
      }
      return Right(LikesModel.fromJson(response.result as Map<String, dynamic>? ?? {}));
    } on DioException catch (dioError) {
      return Left(DioFailure.fromDioError(dioError));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> unlikePost(int postId) async {
    try {
      final userToken = await DI.find<ICacheManager>().getToken();
      final response = await apiService.delete(
        endPoint: '${Constants.postLikesEndpoint}/$postId',
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
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
  Future<Either<Failure, int>> getPostCommentsCount(int postId) async {
    try {
      final userToken = await DI.find<ICacheManager>().getToken();
      final response = await apiService.get(
        endPoint: '${Constants.commentsEndpoint}/$postId/count',
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
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
        endPoint: '${Constants.commentLikesEndpoint}/comment/$commentId',
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
      final userToken = await DI.find<ICacheManager>().getToken();
      final response = await apiService.post(
        endPoint: '${Constants.commentLikesEndpoint}/$commentId',
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
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
      final userToken = await DI.find<ICacheManager>().getToken();
      final response = await apiService.delete(
        endPoint: '${Constants.commentLikesEndpoint}/$commentId',
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
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
      final userToken = await DI.find<ICacheManager>().getToken();
      final response = await apiService.post(
        endPoint: Constants.reportPostEndpoint,
        data: {'postId':postId,'reasonId': reasonId, 'customReason': reason},
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
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
}

