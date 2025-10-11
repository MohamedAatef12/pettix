import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/features/home/domain/usecases/add_comment.dart';
import 'package:pettix/features/home/domain/usecases/add_post.dart';
import 'package:pettix/features/home/domain/usecases/delete_post.dart';
import 'package:pettix/features/home/domain/usecases/dislike_post.dart';
import 'package:pettix/features/home/domain/usecases/get_comments_id.dart';
import 'package:pettix/features/home/domain/usecases/get_posts.dart';
import 'package:pettix/features/home/domain/usecases/get_posts_likes.dart';
import 'package:pettix/features/home/domain/usecases/get_user_cached%20_data.dart';
import 'package:pettix/features/home/domain/usecases/like_post.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';


class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPostsUseCase getPostsUseCase;
  final AddPostUseCase addPostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final AddCommentUseCase addCommentUseCase;
  final GetPostCommentsUseCase getCommentsIdUseCase;
  final GetPostLikesUseCase getPostsLikesUseCase;
  final UnLikePostUseCase unlikePostUseCase;
  final LikePostUseCase likePostUseCase;
  final GetUserDataUseCase getUserDataUseCase;

  final Set<int> throttledPostIds = {};
  final Set<int> loadedBottomSheetPostIds = {};

  final TextEditingController commentTextController = TextEditingController();
  final TextEditingController postTextController = TextEditingController();

  factory HomeBloc.fromDI() {
    return HomeBloc(
      getPostsUseCase: getIt<GetPostsUseCase>(),
      addPostUseCase: getIt<AddPostUseCase>(),
      deletePostUseCase: getIt<DeletePostUseCase>(),
      addCommentUseCase: getIt<AddCommentUseCase>(),
      getCommentsIdUseCase: getIt<GetPostCommentsUseCase>(),
      getPostsLikesUseCase: getIt<GetPostLikesUseCase>(),
      unlikePostUseCase: getIt<UnLikePostUseCase>(),
      likePostUseCase: getIt<LikePostUseCase>(),
      getUserDataUseCase: getIt<GetUserDataUseCase>(),
    );
  }
  HomeBloc({
    required this.getPostsUseCase,
    required this.addPostUseCase,
    required this.deletePostUseCase,
    required this.addCommentUseCase,
    required this.getCommentsIdUseCase,
    required this.getPostsLikesUseCase,
    required this.unlikePostUseCase,
    required this.likePostUseCase,
    required this.getUserDataUseCase,
  }) : super(const HomeState()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<AddPostEvent>(_onAddPost);
    on<DeletePostEvent>(_onDeletePost);
    on<FetchPostsCommentsEvent>(_onFetchPostsComments);
    on<AddCommentEvent>(_onAddComment);
    on<FetchPostsLikesEvent>(_onFetchPostsLikes);
    on<AddLikeEvent>(_onLikePost);
    on<DeleteLikeEvent>(_onUnlikePost);
    on<ClearPostDetailsEvent>(_onClearPostDetails);
  }

  // Posts

  Future<void> _onFetchPosts(
      FetchPostsEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isPostsLoading: true, error: null));
    final result = await getPostsUseCase.call();

    result.fold(
            (failure) =>
            emit(state.copyWith(isPostsLoading: false, error: failure.message)),
            (posts) {
          final postLikesMap = <int, int>{};
          final postCommentsMap = <int, int>{};
          final likedPostIds = <int>{};
          for (var post in posts) {
            if (post.liked) {
              likedPostIds.add(post.id);
            }
            postLikesMap[post.id] = post.likesCount;
            postCommentsMap[post.id] = post.commentsCount;
          }
          emit(state.copyWith(
            posts: posts,
            postLikesCount: postLikesMap,
            likedPostIds: likedPostIds,
            postCommentsCount: postCommentsMap,
            isPostsLoading: false,
          ));
        });
  }

  Future<void> _onAddPost(AddPostEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isAddPostLoading: true, error: null));
    final result = await addPostUseCase.call(event.post);
    await result.fold(
          (failure) async {
        emit(state.copyWith(isAddPostLoading: false, error: failure.message));
      },
          (_) async {
        final postsResult = await getPostsUseCase.call();
        postsResult.fold(
              (failure) => emit(state.copyWith(
              isAddPostLoading: false,
              isPostAdded: false,
              error: failure.message)),
              (posts) => emit(state.copyWith(
              posts: posts,
              isAddPostLoading: false,
              isPostAdded: true,
              error: null)),
        );
      },
    );
  }

  Future<void> _onDeletePost(
      DeletePostEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isPostsLoading: true, error: null));
    final result = await deletePostUseCase.call(event.id);
    result.fold(
          (failure) =>
          emit(state.copyWith(isPostsLoading: false, error: failure.message)),
          (_) async {
        // Optionally, fetch posts again after deleting
        final postsResult = await getPostsUseCase.call();
        postsResult.fold(
              (failure) => emit(
              state.copyWith(isPostsLoading: false, error: failure.message)),
              (posts) => emit(
              state.copyWith(posts: posts, isPostsLoading: false, error: null)),
        );
      },
    );
  }

  // Comments

  Future<void> _onFetchPostsComments(
      FetchPostsCommentsEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isCommentsLoading: true, error: null));
    final result = await getCommentsIdUseCase.call(event.postId);
    result.fold(
          (failure) => emit(
          state.copyWith(isCommentsLoading: false, error: failure.message)),
          (comments) {
        emit(
          state.copyWith(
            comments: comments,
            isCommentsLoading: false,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> _onAddComment(
      AddCommentEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isCommentsLoading: true, error: null));
    final result = await addCommentUseCase.call(event.comment);
    result.fold(
          (failure) => emit(
          state.copyWith(isCommentsLoading: false, error: failure.message)),
          (_) async {
        // Optionally, fetch comments for the post again
        final commentsResult =
        await getCommentsIdUseCase.call(event.comment.postID);
        commentsResult.fold(
              (failure) => emit(
              state.copyWith(isCommentsLoading: false, error: failure.message)),
              (comments) {
            emit(state.copyWith(
              comments: comments,
              isCommentsLoading: false,
              error: null,
            ));
          },
        );
      },
    );
  }

  // Likes

  Future<void> _onFetchPostsLikes(
      FetchPostsLikesEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLikesLoading: true, error: null));
    final result = await getPostsLikesUseCase.call(event.postId);
    result.fold(
          (failure) => emit(state.copyWith(error: failure.message)),
          (likes) {
        emit(state.copyWith(
          postLikesCount: {
            ...state.postLikesCount,
            event.postId: likes.length,
          },
          likes: likes,
          isLikesLoading: false,
        ));
      },
    );
  }

  Future<void> _onLikePost(AddLikeEvent event, Emitter<HomeState> emit) async {
    if (throttledPostIds.contains(event.postId)) return;

    throttledPostIds.add(event.postId);

    final updatedLiked = Set<int>.from(state.likedPostIds)..add(event.postId);
    final currentCount = state.postLikesCount[event.postId] ?? 0;

    // Optimistic update
    emit(state.copyWith(
      likedPostIds: updatedLiked,
      postLikesCount: {
        ...state.postLikesCount,
        event.postId: currentCount + 1,
      },
    ));

    final cached = await getUserDataUseCase.call();
    await cached.fold(
          (failure) {
        // Revert if needed
        final rollbackLiked = Set<int>.from(state.likedPostIds)
          ..remove(event.postId);
        emit(state.copyWith(
          likedPostIds: rollbackLiked,
          postLikesCount: {
            ...state.postLikesCount,
            event.postId: currentCount,
          },
        ));
      },
          (user) async {
        final result = await likePostUseCase.call(event.postId, user.id);
        result.fold(
              (failure) {
            _revertLike(event.postId, emit);
          },
              (_) {
          },
        );
      },
    );
    throttledPostIds.remove(event.postId);
  }

  void _revertLike(int postId, Emitter<HomeState> emit) {
    final updatedLiked = Set<int>.from(state.likedPostIds)..remove(postId);
    final currentCount = state.postLikesCount[postId] ?? 1;
    emit(state.copyWith(
      likedPostIds: updatedLiked,
      postLikesCount: {...state.postLikesCount, postId: currentCount - 1},
    ));
  }

  Future<void> _onUnlikePost(
      DeleteLikeEvent event, Emitter<HomeState> emit) async {
    if (throttledPostIds.contains(event.postId)) return;
    throttledPostIds.add(event.postId);

    final updatedLiked = Set<int>.from(state.likedPostIds)
      ..remove(event.postId);
    final currentCount = state.postLikesCount[event.postId] ?? 1;
    emit(state.copyWith(
      likedPostIds: updatedLiked,
      postLikesCount: {...state.postLikesCount, event.postId: currentCount - 1},
    ));

    final cached = await getUserDataUseCase.call();
    await cached.fold(
          (failure) {
        _revertUnlike(event.postId, emit);
      },
          (user) async {
        final result = await unlikePostUseCase.call(event.postId);
        result.fold(
              (failure) {
            _revertUnlike(event.postId, emit);
          },
              (_) {},
        );
      },
    );

    throttledPostIds.remove(event.postId);
  }

  void _revertUnlike(int postId, Emitter<HomeState> emit) {
    final updatedLiked = Set<int>.from(state.likedPostIds)..add(postId);
    final currentCount = state.postLikesCount[postId] ?? 0;
    emit(state.copyWith(
      likedPostIds: updatedLiked,
      postLikesCount: {...state.postLikesCount, postId: currentCount + 1},
    ));
  }

  void _onClearPostDetails(
      ClearPostDetailsEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      comments: [],
      likes: [],
      isCommentsLoading: false,
      isLikesLoading: false,
      error: null,
    ));
  }
}
