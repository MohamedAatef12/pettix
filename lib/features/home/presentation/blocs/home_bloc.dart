import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/domain/entities/likes_entity.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
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
  final ImagePicker _picker = ImagePicker();

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
    // Existing events
    on<FetchPostsEvent>(_onFetchPosts);
    on<AddPostEvent>(_onAddPost);
    on<DeletePostEvent>(_onDeletePost);
    on<FetchPostsCommentsEvent>(_onFetchPostsComments);
    on<AddCommentEvent>(_onAddComment);
    on<FetchPostsLikesEvent>(_onFetchPostsLikes);
    on<AddLikeEvent>(_onLikePost);
    on<DeleteLikeEvent>(_onUnlikePost);
    on<ClearPostDetailsEvent>(_onClearPostDetails);
    on<PickImageFromGalleryEvent>(_onPickImageFromGallery);
    on<PickImageFromCameraEvent>(_onPickImageFromCamera);
    on<RemoveSelectedImageEvent>(_onRemoveSelectedImage);
    on<SubmitPostEvent>(_onSubmitPost);
  }

  // 📰 FETCH POSTS
  Future<void> _onFetchPosts(
    FetchPostsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isPostsLoading: true, error: null));
    final result = await getPostsUseCase.call();

    result.fold(
      (failure) =>
          emit(state.copyWith(isPostsLoading: false, error: failure.message)),
      (posts) {
        final postLikesMap = <int, int>{};
        final postCommentsMap = <int, int>{};
        final likedPostIds = <int>[];

        for (var post in posts) {
          if (post.liked) likedPostIds.add(post.id);
          postLikesMap[post.id] = post.likesCount;
          postCommentsMap[post.id] = post.commentsCount;
        }

        emit(
          state.copyWith(
            posts: posts,
            postLikesCount: postLikesMap,
            likedPostIds: likedPostIds,
            postCommentsCount: postCommentsMap,
            isPostsLoading: false,
          ),
        );
      },
    );
  }

  // 📝 ADD POST (from backend)
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
          (failure) => emit(
            state.copyWith(
              isAddPostLoading: false,
              isPostAdded: false,
              error: failure.message,
            ),
          ),
          (posts) => emit(
            state.copyWith(
              posts: posts,
              isAddPostLoading: false,
              isPostAdded: true,
              error: null,
            ),
          ),
        );
      },
    );
  }

  // 📸 Pick Image
  Future<void> _onPickImageFromGallery(
    PickImageFromGalleryEvent event,
    Emitter<HomeState> emit,
  ) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(state.copyWith(selectedImage: File(pickedFile.path)));
    }
  }

  // 📷 Pick image (camera)
  Future<void> _onPickImageFromCamera(
    PickImageFromCameraEvent event,
    Emitter<HomeState> emit,
  ) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      emit(state.copyWith(selectedImage: File(pickedFile.path)));
    }
  }

  void _onRemoveSelectedImage(
    RemoveSelectedImageEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(selectedImage: null));
  }

  // 🚀 Submit Post
  Future<void> _onSubmitPost(
    SubmitPostEvent event,
    Emitter<HomeState> emit,
  ) async {
    final text = postTextController.text.trim();
    if (text.isEmpty && state.selectedImage == null) return;

    emit(state.copyWith(isAddPostLoading: true));

    final userResult = await getUserDataUseCase.call();
    await userResult.fold(
      (failure) async {
        emit(state.copyWith(isAddPostLoading: false, error: failure.message));
      },
      (user) async {
        final author = AuthorModel(
          id: user.id,
          userName: user.userName,
          imageUrl: user.image,
          email: user.email,
          password: user.password,
          phone: user.phone,
          country: user.country,
          city: user.city,

          // add other needed fields if AuthorModel has more
        );
        final post = PostEntity(
          id: 0,
          authorID: user.id,
          username: user.userName,
          text: text,
          date: DateTime.now().toIso8601String(),
          imageUrl: state.selectedImage?.path ?? '',
          commentsCount: 0,
          likesCount: 0,
          liked: false,
          author: author,
        );

        final result = await addPostUseCase.call(post);
        result.fold(
          (failure) {
            emit(
              state.copyWith(isAddPostLoading: false, error: failure.message),
            );
          },
          (_) {
            postTextController.clear();
            emit(
              state.copyWith(
                isAddPostLoading: false,
                isPostAdded: true,
                selectedImage: null,
              ),
            );
          },
        );
      },
    );
  }

  // 🗑️ DELETE POST
  Future<void> _onDeletePost(
    DeletePostEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isPostsLoading: true, error: null));
    final result = await deletePostUseCase.call(event.id);

    result.fold(
      (failure) =>
          emit(state.copyWith(isPostsLoading: false, error: failure.message)),
      (_) async {
        final postsResult = await getPostsUseCase.call();
        postsResult.fold(
          (failure) => emit(
            state.copyWith(isPostsLoading: false, error: failure.message),
          ),
          (posts) => emit(
            state.copyWith(posts: posts, isPostsLoading: false, error: null),
          ),
        );
      },
    );
  }

  // 💬 COMMENTS
  Future<void> _onFetchPostsComments(
    FetchPostsCommentsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isCommentsLoading: true, error: null));
    final result = await getCommentsIdUseCase.call(event.postId);

    result.fold(
      (failure) => emit(
        state.copyWith(isCommentsLoading: false, error: failure.message),
      ),
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
    AddCommentEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isCommentsLoading: true, error: null));
    final result = await addCommentUseCase.call(event.comment);

    await result.fold(
      (failure) async {
        emit(state.copyWith(isCommentsLoading: false, error: failure.message));
      },
      (_) async {
        final commentsResult = await getCommentsIdUseCase.call(
          event.comment.postID,
        );
        await commentsResult.fold(
          (failure) async {
            emit(
              state.copyWith(isCommentsLoading: false, error: failure.message),
            );
          },
          (comments) async {
            emit(
              state.copyWith(
                comments: comments,
                isCommentsLoading: false,
                error: null,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onFetchPostsLikes(
    FetchPostsLikesEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await getPostsLikesUseCase.call(event.postId);
    result.fold((failure) => emit(state.copyWith(error: failure.message)), (
      likes,
    ) {
      emit(
        state.copyWith(
          postLikesCount: {...state.postLikesCount, event.postId: likes.length},
          likes: likes,
          isLikesLoading: false,
        ),
      );
    });
  }

  Future<void> _onLikePost(AddLikeEvent event, Emitter<HomeState> emit) async {
    if (throttledPostIds.contains(event.postId)) return;
    throttledPostIds.add(event.postId);

    final currentCount = state.postLikesCount[event.postId] ?? 0;
    final updatedLiked = List<int>.from(state.likedPostIds)..add(event.postId);

    emit(
      state.copyWith(
        likedPostIds: updatedLiked,
        postLikesCount: {
          ...state.postLikesCount,
          event.postId: currentCount + 1,
        },
      ),
    );

    try {
      final cached = await getUserDataUseCase.call();
      await cached.fold((failure) async => _revertLike(event.postId, emit), (
        user,
      ) async {
        final result = await likePostUseCase.call(event.postId, user.id);
        await result.fold((failure) async => _revertLike(event.postId, emit), (
          _,
        ) async {
          add(FetchPostsLikesEvent(event.postId));
        });
      });
    } finally {
      throttledPostIds.remove(event.postId);
    }
  }

  Future<void> _onUnlikePost(
    DeleteLikeEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (throttledPostIds.contains(event.postId)) return;
    throttledPostIds.add(event.postId);

    final currentCount = state.postLikesCount[event.postId] ?? 1;
    final updatedLiked = List<int>.from(state.likedPostIds)
      ..remove(event.postId);

    emit(
      state.copyWith(
        likedPostIds: updatedLiked,
        postLikesCount: {
          ...state.postLikesCount,
          event.postId: currentCount - 1,
        },
      ),
    );

    try {
      final cached = await getUserDataUseCase.call();
      await cached.fold((failure) async => _revertUnlike(event.postId, emit), (
        user,
      ) async {
        final likeEntity = state.likes.firstWhere(
          (l) => l.postID == event.postId && l.userID == user.id,
          orElse: () => LikesEntity(id: 0, userID: 0, postID: 0, date: ''),
        );
        if (likeEntity.id == 0) return;
        final result = await unlikePostUseCase.call(likeEntity.id);
        await result.fold(
          (failure) async => _revertUnlike(event.postId, emit),
          (_) async => add(FetchPostsLikesEvent(event.postId)),
        );
      });
    } finally {
      throttledPostIds.remove(event.postId);
    }
  }

  void _revertLike(int postId, Emitter<HomeState> emit) {
    final updatedLiked = List<int>.from(state.likedPostIds)..remove(postId);
    final currentCount = state.postLikesCount[postId] ?? 1;
    emit(
      state.copyWith(
        likedPostIds: updatedLiked,
        postLikesCount: {
          ...state.postLikesCount,
          postId: currentCount > 0 ? currentCount - 1 : 0,
        },
      ),
    );
  }

  void _revertUnlike(int postId, Emitter<HomeState> emit) {
    final updatedLiked = List<int>.from(state.likedPostIds)..add(postId);
    final currentCount = state.postLikesCount[postId] ?? 0;
    emit(
      state.copyWith(
        likedPostIds: updatedLiked,
        postLikesCount: {...state.postLikesCount, postId: currentCount + 1},
      ),
    );
  }

  void _onClearPostDetails(
    ClearPostDetailsEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        comments: [],
        likes: [],
        isCommentsLoading: false,
        isLikesLoading: false,
        error: null,
      ),
    );
  }
}
