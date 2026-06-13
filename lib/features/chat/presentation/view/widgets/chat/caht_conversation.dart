import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/network/api_services.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
import 'package:pettix/features/adoption_history/domain/usecases/get_client_forms_usecase.dart';
import 'package:pettix/features/adoption_history/domain/usecases/get_owner_forms_usecase.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_event.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_state.dart';
import 'package:pettix/features/chat/presentation/view/widgets/updating_banner.dart';
import 'package:pettix/features/my_pets/data/models/pet_model.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/domain/usecases/get_user_pets_usecase.dart';
import 'package:pettix/features/my_pets/presentation/widgets/pet_passport.dart';
import 'package:pettix/core/widgets/app_cached_image.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

class ChatConversation extends StatefulWidget {
  final int userIndex;
  final AdoptionFormEntity? adoptionForm;

  const ChatConversation({
    super.key,
    required this.userIndex,
    this.adoptionForm,
  });

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _notchController;
  bool _isPetCardOpen = false;
  AdoptionFormEntity? _resolvedAdoptionForm;
  String? _resolvedPairKey;
  bool _isResolvingAdoptionForm = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _notchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      final state = context.read<ChatBloc>().state;
      if (state.hasMore &&
          state.status != ChatStatus.paginating &&
          state.status != ChatStatus.loading) {
        if (state.conversationId != null) {
          context.read<ChatBloc>().add(GetMessagesEvent(state.conversationId!));
        }
      }
    }
  }

  @override
  void dispose() {
    _notchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _togglePetCard() {
    setState(() => _isPetCardOpen = !_isPetCardOpen);
  }

  AdoptionFormEntity? get _activeAdoptionForm =>
      widget.adoptionForm ?? _resolvedAdoptionForm;

  void _resolveAdoptionFormIfNeeded({
    required int? currentUserId,
    required int? otherUserId,
  }) {
    if (widget.adoptionForm != null ||
        currentUserId == null ||
        currentUserId == 0 ||
        otherUserId == null ||
        otherUserId == 0) {
      return;
    }

    final pairKey = '$currentUserId:$otherUserId';
    if (_resolvedPairKey == pairKey || _isResolvingAdoptionForm) return;

    _resolvedPairKey = pairKey;
    _isResolvingAdoptionForm = true;
    _findAdoptionFormForChat(otherUserId).then((form) {
      if (!mounted) return;
      setState(() {
        _resolvedAdoptionForm = form;
        _isResolvingAdoptionForm = false;
      });
    });
  }

  Future<AdoptionFormEntity?> _findAdoptionFormForChat(int otherUserId) async {
    final clientResult = await DI.find<GetClientFormsUseCase>()();
    final clientMatch = clientResult.fold<AdoptionFormEntity?>(
      (_) => null,
      (forms) => _pickBestForm(
        forms.where((form) => form.ownerContactId == otherUserId),
      ),
    );
    if (clientMatch != null) return clientMatch;

    final ownerResult = await DI.find<GetOwnerFormsUseCase>()();
    return ownerResult.fold<AdoptionFormEntity?>(
      (_) => null,
      (forms) => _pickBestForm(
        forms.where((form) => form.clientContactId == otherUserId),
      ),
    );
  }

  AdoptionFormEntity? _pickBestForm(Iterable<AdoptionFormEntity> forms) {
    final list = forms.where((form) => form.petId != null).toList();
    if (list.isEmpty) return null;

    list.sort((a, b) {
      final statusCompare = _statusPriority(
        a.status,
      ).compareTo(_statusPriority(b.status));
      if (statusCompare != 0) return statusCompare;
      return b.id.compareTo(a.id);
    });

    return list.first;
  }

  int _statusPriority(int status) {
    return switch (status) {
      2 => 0, // approved
      1 => 1, // pending
      3 => 2, // rejected
      4 => 3, // cancelled
      _ => 4,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.status == ChatStatus.loading && state.messages.isEmpty) {
          return const Center(child: UpdatingBanner());
        } else if (state.status == ChatStatus.error && state.messages.isEmpty) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final messages = state.messages;
        final isPaginating = state.status == ChatStatus.paginating;
        final otherMember =
            state.conversation?.members
                .where((m) => m.user.id != state.currentUserId)
                .firstOrNull ??
            (state.conversation?.members.isNotEmpty == true
                ? state.conversation?.members.first
                : null);
        _resolveAdoptionFormIfNeeded(
          currentUserId: state.currentUserId,
          otherUserId: otherMember?.user.id,
        );
        final activeAdoptionForm = _activeAdoptionForm;

        return Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              itemCount: messages.length + (isPaginating ? 1 : 0),
              padding: EdgeInsets.only(top: 10.h, bottom: 16.h),
              reverse: true,
              itemBuilder: (context, index) {
                // Pagination spinner sits just above the oldest message, below the card
                if (isPaginating && index == messages.length) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final msg = messages[index];
                final isMe = msg.senderId == state.currentUserId;

                final conversationId = state.conversationId!;
                return ChatBubble(
                  text: msg.content,
                  isMe: isMe,
                  isSending: msg.isSending,
                  isFailed: msg.isFailed,
                  sentAt: msg.sentAt,
                  imageUrl: msg.imageUrl,
                  onResend:
                      msg.isFailed
                          ? () => context.read<ChatBloc>().add(
                            ResendMessageEvent(
                              failedMessageId: msg.id,
                              conversationId: conversationId,
                              content: msg.content,
                              imagePath: msg.imageUrl,
                            ),
                          )
                          : null,
                );
              },
            ),
            if (state.status == ChatStatus.loading)
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: const UpdatingBanner(),
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: _AdoptionNotch(
                animation: _notchController,
                isOpen: _isPetCardOpen,
                onTap: activeAdoptionForm == null ? () {} : _togglePetCard,
              ),
            ),
            if (activeAdoptionForm != null)
              _AdoptionCardOverlay(
                form: activeAdoptionForm,
                isVisible: _isPetCardOpen,
                onClose: _togglePetCard,
              ),
          ],
        );
      },
    );
  }
}

class _AdoptionNotch extends StatelessWidget {
  final Animation<double> animation;
  final bool isOpen;
  final VoidCallback onTap;

  const _AdoptionNotch({
    required this.animation,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.current.green;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final pulse = (sin(animation.value * pi * 2) + 1) / 2;
        return SizedBox(
          width: 32.w,
          height: 44.h,
          child: Stack(
            alignment: Alignment.centerRight,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -9.w,
                child: GestureDetector(
                  onTap: onTap,
                  behavior: HitTestBehavior.translucent,
                  child: Transform.rotate(
                    angle: -1.5708,
                    child: AppIcon.raw(
                      Icons.pets_rounded,
                      color: color,
                      size: 24.w,
                      shadows: [
                        Shadow(
                          color: color.withValues(
                            alpha: lerpDouble(0.18, 0.85, pulse)!,
                          ),
                          blurRadius: lerpDouble(4, 18, pulse)!,
                        ),
                        Shadow(
                          color: color.withValues(
                            alpha: lerpDouble(0.08, 0.38, pulse)!,
                          ),
                          blurRadius: lerpDouble(12, 30, pulse)!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdoptionCardOverlay extends StatelessWidget {
  final AdoptionFormEntity form;
  final bool isVisible;
  final VoidCallback onClose;

  const _AdoptionCardOverlay({
    required this.form,
    required this.isVisible,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isVisible,
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: onClose,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: isVisible ? 1 : 0),
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.82 + (0.18 * value),
                    child: Opacity(opacity: value.clamp(0, 1), child: child),
                  );
                },
                child: _AdoptedPetCard(form: form, onClose: onClose),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdoptedPetCard extends StatefulWidget {
  final AdoptionFormEntity form;
  final VoidCallback onClose;

  const _AdoptedPetCard({required this.form, required this.onClose});

  @override
  State<_AdoptedPetCard> createState() => _AdoptedPetCardState();
}

class _AdoptedPetCardState extends State<_AdoptedPetCard> {
  late Future<PetEntity> _petFuture;

  @override
  void initState() {
    super.initState();
    _petFuture = _loadPet();
  }

  @override
  void didUpdateWidget(covariant _AdoptedPetCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.form.id != widget.form.id ||
        oldWidget.form.petId != widget.form.petId ||
        oldWidget.form.ownerContactId != widget.form.ownerContactId) {
      _petFuture = _loadPet();
    }
  }

  PetEntity _fallbackPet() {
    return PetEntity(
      id: widget.form.petId ?? widget.form.id,
      code: 'PET-${widget.form.petId ?? widget.form.id}',
      name: widget.form.petName ?? AppText.unknownPet,
      categoryName: widget.form.petType,
      adoptionStatus: widget.form.status,
    );
  }

  Future<PetEntity> _loadPet() async {
    final ownerId = widget.form.ownerContactId;
    final petId = widget.form.petId;

    if (petId == null || petId == 0) {
      return _fallbackPet();
    }

    final directPet = await _loadPetById(petId);
    if (directPet != null) return directPet;

    if (ownerId == null || ownerId == 0) return _fallbackPet();

    final result = await DI.find<GetUserPetsUseCase>()(ownerId);
    return result.fold(
      (_) => _fallbackPet(),
      (pets) => pets.firstWhere((pet) => pet.id == petId, orElse: _fallbackPet),
    );
  }

  Future<PetEntity?> _loadPetById(int petId) async {
    try {
      final response = await DI.find<ApiService>().get(
        endPoint: '${Constants.petsEndpoint}/$petId',
      );
      if (response.success != true) return null;

      final raw = response.result;
      final data =
          raw is Map<String, dynamic>
              ? raw
              : raw is Map
              ? Map<String, dynamic>.from(raw)
              : null;

      if (data == null) return null;
      return PetModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: 318.w,
            height: 500.h,
            child: FutureBuilder<PetEntity>(
              future: _petFuture,
              initialData: _fallbackPet(),
              builder: (context, snapshot) {
                final pet = snapshot.data ?? _fallbackPet();

                return PetPassportCard(
                  key: ValueKey('chat_pet_passport_${pet.id}'),
                  pet: pet,
                  initiallyShowingFront: true,
                );
              },
            ),
          ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: widget.onClose,
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                child: AppIcon.raw(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 17.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final String? imageUrl;
  final bool isMe;
  final bool isSending;
  final bool isFailed;
  final DateTime sentAt;
  final VoidCallback? onResend;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.sentAt,
    this.isSending = false,
    this.isFailed = false,
    this.imageUrl,
    this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final timeLabel = DateFormat('h:mm a').format(sentAt.toLocal());
    final metaColor =
        isMe
            ? Colors.white.withValues(alpha: 0.74)
            : AppColors.current.midGray.withValues(alpha: 0.82);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 6.h,
              bottom: 6.h,
              left: isMe ? 52.w : 4.w,
              right: isMe ? 4.w : 52.w,
            ),
            padding:
                imageUrl != null
                    ? EdgeInsets.all(4.r)
                    : EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.55,
            ),
            decoration: BoxDecoration(
              color:
                  isMe
                      ? AppColors.current.primary
                      : AppColors.current.blueGray.withValues(alpha: 0.4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                topRight: Radius.circular(14.r),
                bottomLeft: isMe ? Radius.circular(14.r) : Radius.circular(0),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(14.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imageUrl != null)
                  GestureDetector(
                    onTap: () => _openImagePreview(context, imageUrl!),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: AppCachedImage(
                        imageUrl: imageUrl!,
                        width: 200.w,
                        height: 150.h,
                      ),
                    ),
                  ),
                if (text.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: imageUrl != null ? 8.w : 4.w,
                      vertical: imageUrl != null ? 6.h : 2.h,
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isMe ? Colors.white : AppColors.current.text,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 2.h,
                      left: imageUrl != null ? 8.w : 4.w,
                      right: imageUrl != null ? 8.w : 2.w,
                      bottom: imageUrl != null ? 4.h : 1.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isMe) ...[
                          SizedBox(width: 4.w),
                          AppIcon.raw(
                            isFailed
                                ? Icons.error_outline
                                : isSending
                                ? Icons.access_time_rounded
                                : Icons.done_all,
                            size: 13.r,
                            color:
                                isFailed
                                    ? Colors.redAccent
                                    : Colors.white.withValues(alpha: 0.68),
                          ),
                        ],
                        Spacer(),
                        Text(
                          timeLabel,
                          style: TextStyle(
                            color: metaColor,
                            fontSize: 9.5.sp,
                            height: 1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Resend button shown outside the bubble when failed
          if (isMe && isFailed && onResend != null)
            GestureDetector(
              onTap: onResend,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
                child: AppIcon.raw(
                  Icons.refresh_rounded,
                  size: 18.r,
                  color: Colors.redAccent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openImagePreview(BuildContext context, String path) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black.withValues(alpha: 0.92),
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.88, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (dialogContext, _, __) {
        return GestureDetector(
          onTap: () => Navigator.of(dialogContext).pop(),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {}, // Prevent dismissal when tapping the image
                    child: Hero(
                      tag: 'chat_image_$path',
                      child: InteractiveViewer(
                        minScale: 0.8,
                        maxScale: 4.0,
                        child: AppCachedImage(
                          imageUrl: path,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: GestureDetector(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const AppIcon.raw(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
