import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/domain/usecases/add_comment.dart';
import 'package:pettix/features/home/domain/usecases/add_comment_like.dart';
import 'package:pettix/features/home/domain/usecases/add_post.dart';
import 'package:pettix/features/home/domain/usecases/add_report.dart';
import 'package:pettix/features/home/domain/usecases/delete_post.dart';
import 'package:pettix/features/home/domain/usecases/dislike_post.dart';
import 'package:pettix/features/home/domain/usecases/get_comment_likes.dart';
import 'package:pettix/features/home/domain/usecases/get_comments_id.dart';
import 'package:pettix/features/home/domain/usecases/get_post_comments_count.dart';
import 'package:pettix/features/home/domain/usecases/get_posts.dart';
import 'package:pettix/features/home/domain/usecases/get_posts_likes.dart';
import 'package:pettix/features/home/domain/usecases/get_report_reasons.dart';
import 'package:pettix/features/home/domain/usecases/get_reported_posts.dart';
import 'package:pettix/features/home/domain/usecases/get_user_cached%20_data.dart';
import 'package:pettix/features/home/domain/usecases/like_post.dart';
import 'package:pettix/features/home/domain/usecases/unlike_comment.dart';
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
  final LikeCommentUseCase likeCommentUseCase;
  final UnLikeCommentUseCase unLikeCommentUseCase;
  final GetCommentLikesUseCase getCommentsLike;
  final GetReportReasonsUseCase getReportReasonsUseCase;
  final GetReportedPostsUseCase getReportedPostsUseCase;
  final AddReportUseCase addReportUseCase;
  final Set<int> throttledPostIds = {};
  final Set<int> loadedBottomSheetPostIds = {};
  final TextEditingController commentTextController = TextEditingController();
  final TextEditingController postTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
   String _mentionPrefix = '';


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
      likeCommentUseCase: getIt<LikeCommentUseCase>(),
      unLikeCommentUseCase: getIt<UnLikeCommentUseCase>(),
      getCommentsLike: getIt<GetCommentLikesUseCase>(),
      getReportReasonsUseCase: getIt<GetReportReasonsUseCase>(),
      getReportedPostsUseCase: getIt<GetReportedPostsUseCase>(),
      addReportUseCase: getIt<AddReportUseCase>(),
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
    required this.getCommentsLike,
    required this.unLikeCommentUseCase,
    required this.likeCommentUseCase,
    required this.getReportReasonsUseCase,
    required this.getReportedPostsUseCase,
    required this.addReportUseCase,
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
    on<PickImagesFromGalleryEvent>(_onPickImagesFromGallery);
    on<AddImageFromCameraEvent>(_onAddImageFromCamera);
    on<RemoveSelectedImageEvent>(_onRemoveSelectedImage);
    on<SubmitPostEvent>(_onSubmitPost);
    on<AddReplyEvent>(_onAddReply);
    on<SetReplyingToEvent>(_onSetReplyingTo);
    on<ToggleCommentRepliesEvent>((event, emit) {
      final newExpanded = Map<int, bool>.from(state.expandedComments);
      final current = newExpanded[event.commentId] ?? false;
      newExpanded[event.commentId] = !current;

      emit(state.copyWith(expandedComments: newExpanded));
      commentTextController.addListener(() {
        final text = commentTextController.text;
        final selection = commentTextController.selection;

        // لو في mention موجود
        if (_mentionPrefix.isNotEmpty) {
          // لو المستخدم حذف البداية أو كتب قبل mention
          if (!text.startsWith(_mentionPrefix)) {
            commentTextController.text = _mentionPrefix;
            commentTextController.selection = TextSelection.fromPosition(
              TextPosition(offset: _mentionPrefix.length),
            );
            return;
          }

          // لو المؤشر جوه mention
          if (selection.start < _mentionPrefix.length) {
            commentTextController.selection = TextSelection.fromPosition(
              TextPosition(offset: _mentionPrefix.length),
            );
          }
        }
      });


    });
    on<UpdatePostCommentsCountEvent>(_onUpdatePostCommentsCount);
    on<RefreshCommentsSilentlyEvent>(_onRefreshCommentsSilently);
    on<GetPostCommentsCountsEvent>(_getPostCommentsCount);
    on<AddCommentLikeEvent>(_onAddCommentLike);
    on<GetCommentsLikeEvent>(_onGetCommentLikes);
    on<UnLikeCommentEvent>(_onUnLikeComment);
    on<ReportPostEvent>(_onReportPost);
    on<GetReportReasonsEvent>(_onGetReportReasons);
    on<GetReportedPostsEvent>(_onGetReportedPosts);
  }

  Future<void> _getPostCommentsCount(
    GetPostCommentsCountsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await getPostCommentsCountUseCase(event.postId);

    result.fold((failure) => emit(state.copyWith(error: failure.message)), (
      count,
    ) {
      final updatedMap = Map<int, int>.from(state.postCommentsCount);
      updatedMap[event.postId] = count;
      emit(state.copyWith(postCommentsCount: updatedMap));
    });
  }

  Future<void> _onUpdatePostCommentsCount(
    UpdatePostCommentsCountEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await getPostCommentsCountUseCase.call(event.postId);
    result.fold((failure) => emit(state.copyWith(error: failure.message)), (
      count,
    ) {
      final updatedMap = Map<int, int>.from(state.postCommentsCount)
        ..[event.postId] = count;
      emit(state.copyWith(postCommentsCount: updatedMap));
    });
  }

  Future<void> _onRefreshCommentsSilently(
    RefreshCommentsSilentlyEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await getCommentsIdUseCase.call(event.postId);

    result.fold((failure) => emit(state.copyWith(error: failure.message)), (
      comments,
    ) {
      emit(state.copyWith(comments: comments, error: null));
    });
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

        await Future.wait(
          posts.map((post) async {
            postLikesMap[post.id] = post.likes.length;
            postCommentsMap[post.id] = post.comments.length;

            if (currentUserId != null &&
                post.likes.any((like) => like.author.id == currentUserId)) {
              likedPostIds.add(post.id);
            }

            final countResult = await getPostCommentsCountUseCase.call(post.id);

            countResult.fold(
              (failure) {
                print(
                  "❌ Failed to fetch count for post ${post.id}: ${failure.message}",
                );
              },
              (count) {
                print("✅ Comments count for post ${post.id}: $count");
                postCommentsMap[post.id] =
                    count;
              },
            );
          }),
        );

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

  Future<void> _onAddImageFromCamera(
    AddImageFromCameraEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(selectedImages: [...state.selectedImages, event.image]),
    );
  }

  void _onRemoveSelectedImage(
    RemoveSelectedImageEvent event,
    Emitter<HomeState> emit,
  ) {
    final updated = List<File>.from(state.selectedImages)
      ..removeAt(event.index);
    emit(state.copyWith(selectedImages: updated));
  }

  Future<void> _onSubmitPost(
    SubmitPostEvent event,
    Emitter<HomeState> emit,
  ) async {
    final text = postTextController.text.trim();

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
          images: imagePaths,
          creationDate: DateTime.now().add(const Duration(hours: 2)).toString(),
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
                selectedImages: [],
              ),
            );
          },
        );
      },
    );
  }

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

  Future<void> _onFetchPostsComments(
      FetchPostsCommentsEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(isCommentsLoading: true, error: null));

    final result = await getCommentsIdUseCase.call(event.postId);

    await result.fold(
          (failure) {
        emit(
          state.copyWith(isCommentsLoading: false, error: failure.message),
        );
      },
          (comments) async {
        final updatedLikedCommentIds = <int>{};

        final userResult = await getUserDataUseCase.call();
        int? currentUserId;
        userResult.fold((_) {}, (user) => currentUserId = user.id);

        await Future.wait(comments.map((comment) async {
          final likesResult = await getCommentsLike.call(comment.id);
          likesResult.fold(
                (_) {},
                (likes) {
              if (currentUserId != null &&
                  likes.any((like) => like.author.id == currentUserId)) {
                updatedLikedCommentIds.add(comment.id);
              }
            },
          );
        }));

        emit(
          state.copyWith(
            comments: comments,
            likedCommentId: updatedLikedCommentIds.toList(),
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
      creationDate: DateTime.now().add(const Duration(hours: 2)).toString(),
      likes: [],
      replies: [],
    );

    final updatedComments = List<CommentEntity>.from(state.comments)
      ..insert(0, tempComment);

    final currentCount = state.postCommentsCount[event.comment.postId] ?? 0;
    final updatedCount = Map<int, int>.from(state.postCommentsCount)
      ..[event.comment.postId] = currentCount + 1;

    emit(
      state.copyWith(
        comments: updatedComments,
        postCommentsCount: updatedCount,
        error: null,
      ),
    );

    final result = await addCommentUseCase.call(
      event.comment,
      event.comment.postId,
      null,
    );

    result.fold(
      (failure) {
        final revertedComments = List<CommentEntity>.from(state.comments)
          ..removeWhere((c) => c.id == tempComment.id);

        final revertedCount = Map<int, int>.from(state.postCommentsCount)
          ..[event.comment.postId] =
              (updatedCount[event.comment.postId]! - 1)
                  .clamp(0, double.infinity)
                  .toInt();

        emit(
          state.copyWith(
            comments: revertedComments,
            postCommentsCount: revertedCount,
            error: failure.message,
          ),
        );
      },
      (_) {
        final finalComments =
            List<CommentEntity>.from(state.comments)
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

    final replyingTo = event.comment;
    final controller = commentTextController;

    if (replyingTo != null) {
      final mentionPrefix = '@${replyingTo.author.nameEn}: ';
      controller.text = '$mentionPrefix ';
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );

      _mentionPrefix = mentionPrefix;
    } else {
      controller.clear();
      _mentionPrefix = '';
    }
  }



  Future<void> _onAddReply(AddReplyEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(error: null));

    final tempReply = event.reply.copyWith(
      id: -DateTime.now().millisecondsSinceEpoch,
      text: 'Posting…',
    );

    final optimisticComments =
    state.comments.map((comment) {
      if (comment.id == event.parentCommentId) {
        final updatedReplies = List<CommentEntity>.from(comment.replies)
          ..add(tempReply);
        return comment.copyWith(replies: updatedReplies);
      }
      return comment;
    }).toList();

    emit(state.copyWith(comments: optimisticComments));

    final originalText = event.reply.text;

    final cleanText = event.reply.text.contains(':')
        ? event.reply.text.split(':').last.trim()
        : event.reply.text.trim();

    final replyForUpload = event.reply.copyWith(text: cleanText);

    final result = await addCommentUseCase.call(
      replyForUpload,
      event.reply.postId,
      event.parentCommentId,
    );
    await result.fold(
          (failure) async {
        final revertedComments =
        state.comments.map((comment) {
          if (comment.id == event.parentCommentId) {
            final updatedReplies = List<CommentEntity>.from(comment.replies)
              ..removeWhere((r) => r.id == tempReply.id);
            return comment.copyWith(replies: updatedReplies);
          }
          return comment;
        }).toList();

        emit(
          state.copyWith(comments: revertedComments, error: failure.message),
        );
      },
          (_) async {
        final updatedComments =
        state.comments.map((comment) {
          if (comment.id == event.parentCommentId) {
            final replies =
            List<CommentEntity>.from(comment.replies)
              ..removeWhere((r) => r.id == tempReply.id)
              ..add(event.reply.copyWith(text: originalText));
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

    await Future.delayed(const Duration(milliseconds: 100));

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
  Future<void> _onAddCommentLike(
      AddCommentLikeEvent event,
      Emitter<HomeState> emit,
      ) async {
    final commentId = event.commentId;

    if (throttledPostIds.contains(commentId)) return;
    throttledPostIds.add(commentId);

    final updatedCommentLikes = Map<int, int>.from(state.commentLikesCount);
    final updatedLikedComments = List<int>.from(state.likedCommentId);

    final currentCount = updatedCommentLikes[commentId] ?? 0;
    updatedCommentLikes[commentId] = currentCount + 1;

    if (!updatedLikedComments.contains(commentId)) {
      updatedLikedComments.add(commentId);
    }

    emit(state.copyWith(
      commentLikesCount: updatedCommentLikes,
      likedCommentId: updatedLikedComments,
    ));

    try {
      final cachedUser = await getUserDataUseCase.call();
      await cachedUser.fold(
            (failure) async => _revertCommentLike(commentId, emit),
            (user) async {
          final result = await likeCommentUseCase.call(commentId);
          await result.fold(
                (failure) async => _revertCommentLike(commentId, emit),
                (_) async => add(GetCommentsLikeEvent(commentId)),
          );
        },
      );
    } finally {
      throttledPostIds.remove(commentId);
    }
  }


  Future<void> _onUnLikeComment(
      UnLikeCommentEvent event,
      Emitter<HomeState> emit,
      ) async {
    final commentId = event.commentId;

    if (throttledPostIds.contains(commentId)) return;
    throttledPostIds.add(commentId);

    final updatedCommentLikes =
    Map<int, int>.from(state.commentLikesCount ?? {});
    final updatedLikedComments =
    List<int>.from(state.likedCommentId ?? []);

    final currentCount = updatedCommentLikes[commentId] ?? 1;
    updatedCommentLikes[commentId] =
    currentCount > 0 ? currentCount - 1 : 0;
    updatedLikedComments.remove(commentId);

    emit(
      state.copyWith(
        commentLikesCount: updatedCommentLikes,
        likedCommentId: updatedLikedComments,
      ),
    );

    try {
      final result = await unLikeCommentUseCase.call(commentId);
      await result.fold(
            (failure) async => _revertCommentUnlike(commentId, emit),
            (_) async => add(GetCommentsLikeEvent(commentId)),
      );
    } finally {
      throttledPostIds.remove(commentId);
    }
  }

  Future<void> _onGetCommentLikes(
      GetCommentsLikeEvent event,
      Emitter<HomeState> emit,
      ) async {
    final commentId = event.commentId;

    final result = await getCommentsLike.call(commentId);

    if (result.isLeft()) {
      emit(state.copyWith(error: result.swap().getOrElse(() => throw '').message));
      return;
    }

    final likes = result.getOrElse(() => []);

    final updatedMap = Map<int, int>.from(state.commentLikesCount ?? {});
    updatedMap[commentId] = likes.length;

    final userResult = await getUserDataUseCase.call();

    if (userResult.isLeft()) {
      emit(state.copyWith(commentLikesCount: updatedMap, error: null));
      return;
    }

    final user = userResult.getOrElse(() => throw '');
    final likedCommentIds = List<int>.from(state.likedCommentId ?? []);

    final isLikedByUser = likes.any((like) => like.author.id == user.id);

    if (isLikedByUser && !likedCommentIds.contains(commentId)) {
      likedCommentIds.add(commentId);
    } else if (!isLikedByUser && likedCommentIds.contains(commentId)) {
      likedCommentIds.remove(commentId);
    }

    emit(
      state.copyWith(
        commentLikesCount: updatedMap,
        likedCommentId: likedCommentIds,
        error: null,
      ),
    );
  }

  void _revertCommentLike(int commentId, Emitter<HomeState> emit) {
    final updatedLikedComments =
    List<int>.from(state.likedCommentId ?? [])..remove(commentId);
    final updatedCounts = Map<int, int>.from(state.commentLikesCount ?? {});
    final currentCount = updatedCounts[commentId] ?? 1;
    updatedCounts[commentId] =
    currentCount > 0 ? currentCount - 1 : 0;

    emit(
      state.copyWith(
        commentLikesCount: updatedCounts,
        likedCommentId: updatedLikedComments,
      ),
    );
  }

  void _revertCommentUnlike(int commentId, Emitter<HomeState> emit) {
    final updatedLikedComments =
    List<int>.from(state.likedCommentId ?? [])..add(commentId);
    final updatedCounts = Map<int, int>.from(state.commentLikesCount ?? {});
    final currentCount = updatedCounts[commentId] ?? 0;
    updatedCounts[commentId] = currentCount + 1;

    emit(
      state.copyWith(
        commentLikesCount: updatedCounts,
        likedCommentId: updatedLikedComments,
      ),
    );
  }
Future<void> _onReportPost(
      ReportPostEvent event,
      Emitter<HomeState> emit,
      ) async {
    final result = await addReportUseCase.call(event.postId, event.reasonId,event.reason);

    result.fold(
          (failure) => emit(state.copyWith(error: failure.message)),
        (success) {

        }
    );
  }
  Future<void> _onGetReportReasons(
      GetReportReasonsEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(isReportLoading: true));

    final result = await getReportReasonsUseCase();

    result.fold(
          (failure) {
        emit(state.copyWith(
          isReportLoading: false,
          error: failure.message,
        ));
      },
          (reasons) {
        emit(state.copyWith(
          isReportLoading: false,
          reportReasons: reasons,
        ));
      },
    );
  }




  Future<void> _onGetReportedPosts(
      GetReportedPostsEvent event,
      Emitter<HomeState> emit,
      ) async {
    final result = await getReportedPostsUseCase.call(event.postId);

    result.fold(
          (failure) {
        emit(state.copyWith(error: failure.message));
      },
          (_) {
      },
    );
  }

}
