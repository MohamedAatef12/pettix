import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/entities/register_domain_entity.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/data/models/comments_model.dart';
import 'package:pettix/features/home/data/models/likes_model.dart';
import 'package:pettix/features/home/data/models/post_model.dart';
import 'package:pettix/features/home/data/sources/local/local_data_source.dart';
import 'package:pettix/features/home/data/sources/remote/home_remote_data_source.dart';
import 'package:pettix/features/home/domain/entities/author_entity.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/domain/entities/likes_entity.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
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
      (models) => Right(models
          .map((model) => model.toEntity(
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
              ))
          .toList()),
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
      int postId) async {
    final result = await remoteDataSource.getPostComments(postId);

    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models
          .map((model) => model.toEntity(
                CommentModel(
                  id: model.id,
                  text: model.text,
                  author: model.author,
                  creationDate: model.creationDate,
                  postId: model.postId,
                  parentCommentId: model.parentCommentId,
                  replies: model.replies,

                ),
              ))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, void>> addComment(CommentEntity comment) async {
    final commentModel = CommentModel.fromEntity(comment);
    return remoteDataSource.addComment(commentModel);
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
      (likes) => Right(likes
          .map((like) => like.toEntity(
                LikesModel(
                  id: like.id,
                  author: like.author,
                  creationDate: like.creationDate,
                  postId: like.postId,

                ),
              ))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, LikesEntity>> likePost(int postId, int userId) async {
    final result = await remoteDataSource.likePost(postId, userId);

    return result.fold((failure) => Left(failure), (success) {
      print('[Repo] Calling remoteDataSource.likePost()');

      return Right(LikesModel(
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
      ));
    });
  }

  @override
  Future<Either<Failure, void>> unlikePost(
    int postId,
  ) async {
    final result = await remoteDataSource.unlikePost(postId);
    return result.fold(
      (failure) => Left(failure),
      (success) => Right(null),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> getCachedUserData() async {
    try {
      return Right(homeLocalDataSource.getUserData());
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }
}
