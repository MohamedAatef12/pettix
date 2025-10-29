import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/data/models/likes_model.dart';
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
    on<PickImagesFromGalleryEvent>(_onPickImagesFromGallery);
    on<AddImageFromCameraEvent>(_onAddImageFromCamera);
    on<RemoveSelectedImageEvent>(_onRemoveSelectedImage);
    on<SubmitPostEvent>(_onSubmitPost);
  }

  // 📰 FETCH POSTS
// 📰 FETCH POSTS
  Future<void> _onFetchPosts(
      FetchPostsEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(isPostsLoading: true, error: null));
    final result = await getPostsUseCase.call();

    final userResult = await getUserDataUseCase.call();
    int? currentUserId;
    userResult.fold((_) {}, (user) => currentUserId = user.id);

    result.fold(
          (failure) =>
          emit(state.copyWith(isPostsLoading: false, error: failure.message)),
          (posts) {
        final postLikesMap = <int, int>{};
        final postCommentsMap = <int, int>{};
        final likedPostIds = <int>[];

        for (var post in posts) {
          postLikesMap[post.id] = post.likes.length;
          postCommentsMap[post.id] = post.comments.length;

          // ✅ Detect if the current user has liked this post
          if (currentUserId != null &&
              post.likes.any((like) => like.author.id == currentUserId)) {
            likedPostIds.add(post.id);
          }
        }

        emit(
          state.copyWith(
            posts: posts,
            postLikesCount: postLikesMap,
            postCommentsCount: postCommentsMap,
            likedPostIds: likedPostIds,
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

// 📸 Pick multiple from gallery
  Future<void> _onPickImagesFromGallery(
      PickImagesFromGalleryEvent event,
      Emitter<HomeState> emit,
      ) async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      final files = pickedFiles.map((e) => File(e.path)).toList();
      emit(state.copyWith(selectedImages: [...state.selectedImages, ...files]));
    }
  }

// 📷 Add from camera
  Future<void> _onAddImageFromCamera(
      AddImageFromCameraEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(selectedImages: [...state.selectedImages, event.image]));
  }

// ❌ Remove image
  void _onRemoveSelectedImage(
      RemoveSelectedImageEvent event,
      Emitter<HomeState> emit,
      ) {
    final updated = List<File>.from(state.selectedImages)..removeAt(event.index);
    emit(state.copyWith(selectedImages: updated));
  }

  // 🚀 Submit Post
  Future<void> _onSubmitPost(
      SubmitPostEvent event,
      Emitter<HomeState> emit,
      ) async {
    final text = postTextController.text.trim();

    // ✅ تأكد أن فيه محتوى أو صور
    if (text.isEmpty && state.selectedImages.isEmpty) return;

    emit(state.copyWith(isAddPostLoading: true));

    final userResult = await getUserDataUseCase.call();
    await userResult.fold(
          (failure) async {
        emit(state.copyWith(isAddPostLoading: false, error: failure.message));
      },
          (user) async {
        final author = AuthorModel(
          id: user.id,
          nameEn: user.userName,
          nameAr: '',
          avatar: user.avatar,
          email: user.email,
          contactTypeId: user.contactTypeId,
          phone: user.phone,
          genderId: user.genderId,
          genderName: user.gender,
          statusId: user.statusId,
          age: user.age,
        );

        // ✅ لو فيه صور، حولها لقائمة من الـ paths
        final imagePaths = state.selectedImages.map((file) => file.path).toList();

        final post = PostEntity(
          id: 0,
          author: author,
          content: text,
          images: imagePaths, // 🧠 هنا التعديل
          creationDate: DateTime.now().toIso8601String(),
          comments: [],
          likes: [],
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
                selectedImages: [], // ✅ نرجعها فاضية بدل null
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
          event.comment.postId,
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
        final post = state.posts.firstWhere(
              (p) => p.id == event.postId,
        );

        final likeEntity = post.likes.firstWhere(
              (l) => l.author.id == user.id,
          orElse: () => LikesModel(
            id: 0,
            author: AuthorModel(
              id: user.id,
              email: user.email,
              nameAr: user.userName,
              nameEn: user.userName,
              phone: user.phone,
              genderId: user.genderId,
              genderName: user.gender,
              contactTypeId: user.contactTypeId,
              statusId: user.statusId,
              avatar: user.avatar,
              age: user.age,
            ),
            postId: event.postId,
            creationDate: DateTime.now().toIso8601String(),
          ),
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
