import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/api_services.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/data/network/failure.dart';
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
    final userToken =await DI.find<ICacheManager>().getToken();
    print('🔑 userToken: $userToken');
    try {
      final data = await apiService.getList(
        endPoint: Constants.postsEndpoint,
        headers: {
      'Authorization': 'Bearer $userToken'},
      );
      final posts = data.map((e) => PostModel.fromJson(e)).toList();
      // Sort posts by date descending (latest first)
      posts.sort(
          (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

      return Right(posts);
    } catch (e) {
      log('Error fetching posts: $e');
      return Left(DioFailure.fromDioError(e));
    }
  }

  // Future<Either<Failure, List<PostModel>>> getPostsById(post.id) async {
  //   try {
  //     final data = await apiService.get(
  //       endPoint: '${Constants.postsEndpoint}/${post.id}',
  //     );
  //
  //     final posts = data.map((e) => PostModel.fromJson(e)).toList();
  //
  //     // Sort posts by date descending (latest first)
  //     posts.sort(
  //         (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
  //
  //     return Right(posts);
  //   } catch (e) {
  //     log('Error fetching posts: $e');
  //     return Left(DioFailure.fromDioError(e));
  //   }
  // }

  @override
  Future<Either<Failure, void>> editPost(PostModel post) async {
    try {
      await apiService.put(
        endPoint: '${Constants.postsEndpoint}/${post.id}',
        data: post.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> addPost(PostModel post) async {
    try {
      log('Adding post: ${post.toJson()}');
      await apiService.post(
        endPoint: Constants.postsEndpoint,
        data: post.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      return const Right(null);
    } catch (e) {
      log('Error adding post: $e');
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(int id) async {
    try {
      await apiService.delete(endPoint: '${Constants.postsEndpoint}/$id');
      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  // Comments

  @override
  Future<Either<Failure, List<CommentModel>>> getPostComments(
      int postId) async {
    try {
      final data = await apiService.getList(
        endPoint: '${Constants.commentsEndpoint}/PostComments/$postId',
      );

      final comments = data.map((e) => CommentModel.fromJson(e)).toList();
      // Sort comments by date descending (latest first)
      comments.sort(
          (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

      if (comments.isEmpty) {
        return const Right([]);
      }

      return Right(comments);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> addComment(CommentModel comment) async {
    try {
      await apiService.post(
        endPoint: Constants.commentsEndpoint,
        data: comment.toJson(),
      );

      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(int id) async {
    try {
      await apiService.delete(endPoint: '${Constants.commentsEndpoint}/$id');
      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> editComment(CommentModel comment) async {
    try {
      await apiService.put(
        endPoint: '${Constants.commentsEndpoint}/${comment.id}',
        data: comment.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  // Likes

  @override
  Future<Either<Failure, List<LikesModel>>> getPostLikes(int postId) async {
    try {
      final data = await apiService.getList(
        endPoint: '${Constants.likesEndpoint}/Postlikes/$postId',
      );

      final likes = data.map((e) => LikesModel.fromJson(e)).toList();
      // Sort likes by date descending (latest first)
      likes.sort(
          (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
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
      final data = await apiService.post(
        endPoint: Constants.likesEndpoint,
        data: {
          'postID': postId,
          'userID': userId,
          'date': DateTime.now().toIso8601String(),
        },
      );
      print('[RemoteDataSource] Sending like request for post $postId');

      return Right(LikesModel.fromJson(data));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> unlikePost(int postId) async {
    try {
      final response = await apiService.delete(
        endPoint: '${Constants.likesEndpoint}/$postId',
      );

      return Right(null);
    } on DioException catch (dioError) {
      return Left(DioFailure.fromDioError(dioError));
    } catch (e, stackTrace) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }
}
