import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/domain/usecases/add_comment.dart';
import 'package:pettix/features/home/domain/usecases/add_post.dart';
import 'package:pettix/features/home/domain/usecases/delete_post.dart';
import 'package:pettix/features/home/domain/usecases/dislike_post.dart';
import 'package:pettix/features/home/domain/usecases/get_comments_id.dart';
import 'package:pettix/features/home/domain/usecases/get_post_comments_count.dart';
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
  final GetPostCommentsCountsUseCase getPostCommentsCountUseCase;

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
      getPostCommentsCountUseCase: getIt<GetPostCommentsCountsUseCase>(),
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
    required this.getPostCommentsCountUseCase,
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
    on<AddReplyEvent>(_onAddReply);
    on<SetReplyingToEvent>(_onSetReplyingTo);
    on<ToggleCommentRepliesEvent>((event, emit) {
      final newExpanded = Map<int, bool>.from(state.expandedComments);
      final current = newExpanded[event.commentId] ?? false;
      newExpanded[event.commentId] = !current; // Toggle value

      emit(state.copyWith(expandedComments: newExpanded));
    });
    on<UpdatePostCommentsCountEvent>(_onUpdatePostCommentsCount);
    on<RefreshCommentsSilentlyEvent>(_onRefreshCommentsSilently);
    on<GetPostCommentsCountsEvent>(_getPostCommentsCount);
  }
  Future<void> _getPostCommentsCount(
      GetPostCommentsCountsEvent event,
      Emitter<HomeState> emit,
      ) async {
    final result = await getPostCommentsCountUseCase(event.postId);

    result.fold(
          (failure) => emit(state.copyWith(error: failure.message)),
          (count) {
        final updatedMap = Map<int, int>.from(state.postCommentsCount);
        updatedMap[event.postId] = count;
        emit(state.copyWith(postCommentsCount: updatedMap));
      },
    );
  }
  Future<void> _onUpdatePostCommentsCount(
      UpdatePostCommentsCountEvent event,
      Emitter<HomeState> emit,
      ) async {
    final result = await getPostCommentsCountUseCase.call(event.postId);
    result.fold(
          (failure) => emit(state.copyWith(error: failure.message)),
          (count) {
        final updatedMap = Map<int, int>.from(state.postCommentsCount)
          ..[event.postId] = count;
        emit(state.copyWith(postCommentsCount: updatedMap));
      },
    );
  }
  Future<void> _onRefreshCommentsSilently(
      RefreshCommentsSilentlyEvent event,
      Emitter<HomeState> emit,
      ) async {
    final result = await getCommentsIdUseCase.call(event.postId);

    result.fold(
          (failure) => emit(state.copyWith(error: failure.message)),
          (comments) {
        emit(state.copyWith(comments: comments, error: null));
      },
    );
  }

  Future<void> _onFetchPosts(
      FetchPostsEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(isPostsLoading: true, error: null));

    final result = await getPostsUseCase.call();
    final userResult = await getUserDataUseCase.call();

    int? currentUserId;
    userResult.fold((_) {}, (user) => currentUserId = user.id);

    await result.fold(
          (failure) async {
        emit(state.copyWith(isPostsLoading: false, error: failure.message));
      },
          (posts) async {
        final postLikesMap = <int, int>{};
        final postCommentsMap = <int, int>{};
        final likedPostIds = <int>[];

        // ✅ نستخدم Future.wait بدل await في اللوب
        await Future.wait(posts.map((post) async {
          postLikesMap[post.id] = post.likes.length;
          postCommentsMap[post.id] = post.comments.length;

          // ✅ Detect liked posts
          if (currentUserId != null &&
              post.likes.any((like) => like.author.id == currentUserId)) {
            likedPostIds.add(post.id);
          }

          // ✅ Call endpoint to get comment count safely
          final countResult = await getPostCommentsCountUseCase.call(post.id);

          countResult.fold(
                (failure) {
              print("❌ Failed to fetch count for post ${post.id}: ${failure.message}");
            },
                (count) {
              print("✅ Comments count for post ${post.id}: $count");
              postCommentsMap[post.id] = count; // ✅ استخدم الماب المحلي مش state
            },
          );
        }));


        // ✅ بعد ما تخلص كل الكولات
        emit(
          state.copyWith(
            posts: posts,
            postLikesCount: postLikesMap,
            postCommentsCount: postCommentsMap, // ✅ هنا القيم الصح بعد الـ API
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
    emit(
      state.copyWith(selectedImages: [...state.selectedImages, event.image]),
    );
  }

  // ❌ Remove image
  void _onRemoveSelectedImage(
    RemoveSelectedImageEvent event,
    Emitter<HomeState> emit,
  ) {
    final updated = List<File>.from(state.selectedImages)
      ..removeAt(event.index);
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
        final imagePaths =
            state.selectedImages.map((file) => file.path).toList();

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
                selectedImages: [],       ),
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
   final replyingToBeforeSend = state.replyingTo;
    emit(state.copyWith(replyingTo: null));
    if (event.comment.parentCommentId != null &&
        replyingToBeforeSend != null &&
        replyingToBeforeSend.id == event.comment.parentCommentId) {
      add(AddReplyEvent(event.comment, event.comment.parentCommentId!));
      return;
    }
   final tempComment = CommentEntity(
      id: -DateTime.now().millisecondsSinceEpoch,
      postId: event.comment.postId,
      parentCommentId: null,
      author: event.comment.author,
      text: 'Posting…',
      creationDate: DateTime.now().toIso8601String(),
      replies: [],
    );
    final updatedComments = List<CommentEntity>.from(state.comments)
      ..insert(0, tempComment);
    emit(state.copyWith(comments: updatedComments, error: null));

    final result = await addCommentUseCase.call(
      event.comment,
      event.comment.postId,
      null,
    );
   result.fold(
         (failure) {
       final reverted = List<CommentEntity>.from(state.comments)
         ..removeWhere((c) => c.id == tempComment.id);
       emit(state.copyWith(comments: reverted, error: failure.message));
     },
         (_) {
       final finalComments = List<CommentEntity>.from(state.comments)
         ..removeWhere((c) => c.id == tempComment.id)
         ..insert(0, event.comment);
       emit(state.copyWith(comments: finalComments, error: null));
       add(RefreshCommentsSilentlyEvent(event.comment.postId));
       add(GetPostCommentsCountsEvent(event.comment.postId));
     },
   );

   commentTextController.clear();
  }



  Future<void> _onSetReplyingTo(
      SetReplyingToEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(replyingTo: event.comment));
  }

  Future<void> _onAddReply(
      AddReplyEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(error: null));

    final tempReply = event.reply.copyWith(
      id: -DateTime.now().millisecondsSinceEpoch,
      text: 'Posting…',
    );

    final optimisticComments = state.comments.map((comment) {
      if (comment.id == event.parentCommentId) {
        final updatedReplies = List<CommentEntity>.from(comment.replies)
          ..add(tempReply);
        return comment.copyWith(replies: updatedReplies);
      }
      return comment;
    }).toList();

    emit(state.copyWith(comments: optimisticComments));

    final result = await addCommentUseCase.call(
      event.reply,
      event.reply.postId,
      event.parentCommentId,
    );

    await result.fold(
          (failure) async {
        final revertedComments = state.comments.map((comment) {
          if (comment.id == event.parentCommentId) {
            final updatedReplies = List<CommentEntity>.from(comment.replies)
              ..removeWhere((r) => r.id == tempReply.id);
            return comment.copyWith(replies: updatedReplies);
          }
          return comment;
        }).toList();

        emit(state.copyWith(comments: revertedComments, error: failure.message));
      },
          (_) async {
        final updatedComments = state.comments.map((comment) {
          if (comment.id == event.parentCommentId) {
            final replies = List<CommentEntity>.from(comment.replies)
              ..removeWhere((r) => r.id == tempReply.id)
              ..add(event.reply);
            return comment.copyWith(replies: replies);
          }
          return comment;
        }).toList();

        emit(state.copyWith(comments: updatedComments, error: null));
        add(RefreshCommentsSilentlyEvent(event.reply.postId));
        add(GetPostCommentsCountsEvent(event.reply.postId));

      },
    );
    commentTextController.clear();

    await Future.delayed(Duration(milliseconds: 100));

    emit(state.copyWith(replyingTo: null));
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

    // Optimistic UI update
    emit(
      state.copyWith(
        likedPostIds: updatedLiked,
        postLikesCount: {
          ...state.postLikesCount,
          event.postId: (currentCount > 0 ? currentCount - 1 : 0),
        },
      ),
    );

    try {
      final cached = await getUserDataUseCase.call();
      await cached.fold((failure) async => _revertUnlike(event.postId, emit), (
        user,
      ) async {
        final result = await unlikePostUseCase.call(event.postId);
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
