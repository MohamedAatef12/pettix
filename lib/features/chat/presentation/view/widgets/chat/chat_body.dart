import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/enums/app_enums.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/pet_toast.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
import 'package:pettix/features/adoption_history/domain/usecases/get_owner_forms_usecase.dart';
import 'package:pettix/features/adoption_history/domain/usecases/update_adoption_form_status_usecase.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_bloc.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_event.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_state.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/caht_conversation.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/chat_text_form_fied.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

class ChatBody extends StatefulWidget {
  final int index;
  final AdoptionFormEntity? adoptionForm;
  final AdoptionHistoryBloc? adoptionHistoryBloc;

  const ChatBody({
    super.key,
    required this.index,
    this.adoptionForm,
    this.adoptionHistoryBloc,
  });

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  AdoptionFormEntity? _resolvedOwnerForm;
  String? _resolvedPairKey;
  bool _isResolvingOwnerForm = false;
  bool _isUpdatingFormStatus = false;
  int? _localStatus;

  @override
  void initState() {
    super.initState();
    _localStatus = widget.adoptionForm?.status;
  }

  @override
  void didUpdateWidget(covariant ChatBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adoptionForm?.id != widget.adoptionForm?.id ||
        oldWidget.adoptionForm?.status != widget.adoptionForm?.status) {
      _localStatus = widget.adoptionForm?.status;
      _resolvedOwnerForm = null;
      _resolvedPairKey = null;
    }
  }

  AdoptionFormEntity? get _activeAdoptionForm {
    final form = widget.adoptionForm ?? _resolvedOwnerForm;
    if (form == null || _localStatus == null) return form;
    return _copyFormWithStatus(form, _localStatus!);
  }

  void _resolveOwnerFormIfNeeded({
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
    if (_resolvedPairKey == pairKey || _isResolvingOwnerForm) return;

    _resolvedPairKey = pairKey;
    _isResolvingOwnerForm = true;
    DI.find<GetOwnerFormsUseCase>()().then((result) {
      final form = result.fold<AdoptionFormEntity?>(
        (_) => null,
        (forms) => _pickBestOwnerForm(
          forms.where(
            (form) =>
                form.ownerContactId == currentUserId &&
                form.clientContactId == otherUserId,
          ),
        ),
      );

      if (!mounted) return;
      setState(() {
        _resolvedOwnerForm = form;
        _localStatus = form?.status;
        _isResolvingOwnerForm = false;
      });
    });
  }

  AdoptionFormEntity? _pickBestOwnerForm(Iterable<AdoptionFormEntity> forms) {
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
      1 => 0,
      2 => 1,
      3 => 2,
      4 => 3,
      _ => 4,
    };
  }

  Future<void> _updateFormStatus(int status) async {
    final form = _activeAdoptionForm;
    if (form == null || _isUpdatingFormStatus) return;

    setState(() => _isUpdatingFormStatus = true);
    final result = await DI.find<UpdateAdoptionFormStatusUseCase>()(
      form.id,
      status,
    );

    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() => _isUpdatingFormStatus = false);
        PetToast.showError(context, failure.message);
      },
      (_) {
        setState(() {
          _localStatus = status;
          _isUpdatingFormStatus = false;
        });
        widget.adoptionHistoryBloc?.add(const FetchOwnerFormsEvent());
        PetToast.showSuccess(context, AppText.statusUpdatedSuccessfully);
      },
    );
  }

  AdoptionFormEntity _copyFormWithStatus(AdoptionFormEntity form, int status) {
    return AdoptionFormEntity(
      id: form.id,
      fullName: form.fullName,
      email: form.email,
      phoneNumber: form.phoneNumber,
      dateOfBirth: form.dateOfBirth,
      livingSituationId: form.livingSituationId,
      typeOfResidenceId: form.typeOfResidenceId,
      livingSituation: form.livingSituation,
      typeOfResidence: form.typeOfResidence,
      hasOwnedOrCaredForPetBefore: form.hasOwnedOrCaredForPetBefore,
      petType: form.petType,
      agreesToTerms: form.agreesToTerms,
      petId: form.petId,
      petName: form.petName,
      status: status,
      clientContactId: form.clientContactId,
      ownerContactId: form.ownerContactId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final otherMember =
            state.conversation?.members
                .where((m) => m.user.id != state.currentUserId)
                .firstOrNull ??
            (state.conversation?.members.isNotEmpty == true
                ? state.conversation?.members.first
                : null);

        _resolveOwnerFormIfNeeded(
          currentUserId: state.currentUserId,
          otherUserId: otherMember?.user.id,
        );

        final activeAdoptionForm = _activeAdoptionForm;
        final isOwnerSide =
            activeAdoptionForm?.ownerContactId != null &&
            activeAdoptionForm?.ownerContactId == state.currentUserId;
        final isPending =
            AdoptionFormStatus.fromValue(activeAdoptionForm?.status) ==
            AdoptionFormStatus.pending;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.current.lightBlue,
                AppColors.current.white.withValues(alpha: 0.96),
                AppColors.current.primary.withValues(alpha: 0.08),
              ],
              stops: const [0, 0.58, 1],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _ChatBgPainter())),
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.w, right: 2.w),
                      child: ChatConversation(
                        userIndex: widget.index,
                        adoptionForm: activeAdoptionForm,
                      ),
                    ),
                  ),
                  Padding(
                    padding: PaddingConstants.medium,
                    child: Column(
                      children: [
                        if (isOwnerSide && isPending)
                          _ChatAdoptionActions(
                            petName: activeAdoptionForm?.petName,
                            isLoading: _isUpdatingFormStatus,
                            onAccept:
                                () => _updateFormStatus(
                                  AdoptionFormStatus.approved.value,
                                ),
                            onDecline:
                                () => _updateFormStatus(
                                  AdoptionFormStatus.rejected.value,
                                ),
                          ),
                        if (state.conversationId != null)
                          ChatTextFormField(
                            conversationId: state.conversationId!,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatAdoptionActions extends StatelessWidget {
  final String? petName;
  final bool isLoading;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _ChatAdoptionActions({
    required this.petName,
    required this.isLoading,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.current.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.current.primary.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.primary.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: AppColors.current.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: AppIcon.raw(
              Icons.pets_rounded,
              color: AppColors.current.primary,
              size: 18.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              petName == null
                  ? AppText.reviewApplication
                  : '${AppText.reviewApplication}: $petName',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.current.text,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          if (isLoading)
            SizedBox(
              width: 22.w,
              height: 22.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: AppColors.current.primary,
              ),
            )
          else ...[
            _DecisionButton(
              icon: Icons.close_rounded,
              label: AppText.reject,
              color: AppColors.current.red,
              isOutlined: true,
              onTap: onDecline,
            ),
            SizedBox(width: 8.w),
            _DecisionButton(
              icon: Icons.check_rounded,
              label: AppText.accept,
              color: AppColors.current.green,
              onTap: onAccept,
            ),
          ],
        ],
      ),
    );
  }
}

class _DecisionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isOutlined;
  final VoidCallback onTap;

  const _DecisionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: isOutlined ? color.withValues(alpha: 0.08) : color,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withValues(alpha: 0.75)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon.raw(
                icon,
                color: isOutlined ? color : Colors.white,
                size: 16.w,
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  color: isOutlined ? color : Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final primary = AppColors.current.primary;
    final teal = AppColors.current.teal;
    final gold = AppColors.current.gold;

    final bandPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 26.w
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    final topRibbon =
        Path()
          ..moveTo(-size.width * 0.18, size.height * 0.18)
          ..cubicTo(
            size.width * 0.25,
            size.height * 0.04,
            size.width * 0.54,
            size.height * 0.32,
            size.width * 1.18,
            size.height * 0.13,
          );
    bandPaint.color = primary.withValues(alpha: 0.055);
    canvas.drawPath(topRibbon, bandPaint);

    final lowerRibbon =
        Path()
          ..moveTo(-size.width * 0.10, size.height * 0.82)
          ..cubicTo(
            size.width * 0.24,
            size.height * 0.68,
            size.width * 0.58,
            size.height * 0.94,
            size.width * 1.10,
            size.height * 0.70,
          );
    bandPaint
      ..color = teal.withValues(alpha: 0.052)
      ..strokeWidth = 22.w;
    canvas.drawPath(lowerRibbon, bandPaint);

    final accentRibbon =
        Path()
          ..moveTo(size.width * 0.76, -size.height * 0.08)
          ..cubicTo(
            size.width * 0.64,
            size.height * 0.28,
            size.width * 0.98,
            size.height * 0.48,
            size.width * 0.70,
            size.height * 1.08,
          );
    bandPaint
      ..color = gold.withValues(alpha: 0.042)
      ..strokeWidth = 18.w;
    canvas.drawPath(accentRibbon, bandPaint);

    final linePaint =
        Paint()
          ..color = primary.withValues(alpha: 0.018)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
    for (double y = 28.h; y < size.height; y += 42.h) {
      final path =
          Path()
            ..moveTo(0, y)
            ..quadraticBezierTo(size.width * 0.5, y + 9.h, size.width, y);
      canvas.drawPath(path, linePaint);
    }

    final pawGlowPaint =
        Paint()
          ..color = primary.withValues(alpha: 0.055)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.2);
    final pawPaint =
        Paint()
          ..color = primary.withValues(alpha: 0.082)
          ..style = PaintingStyle.fill;
    final dotGlowPaint =
        Paint()
          ..color = primary.withValues(alpha: 0.064)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    final dotPaint =
        Paint()
          ..color = primary.withValues(alpha: 0.095)
          ..style = PaintingStyle.fill;

    final positions = [
      Offset(size.width * 0.16, size.height * 0.16),
      Offset(size.width * 0.86, size.height * 0.28),
      Offset(size.width * 0.18, size.height * 0.56),
      Offset(size.width * 0.78, size.height * 0.78),
      Offset(size.width * 0.46, size.height * 0.42),
    ];

    for (var i = 0; i < positions.length; i++) {
      _drawPaw(
        canvas,
        positions[i],
        pawGlowPaint,
        dotGlowPaint,
        scale: i.isEven ? 1.08 : 0.9,
        angle: i.isEven ? -0.18 : 0.22,
      );
      _drawPaw(
        canvas,
        positions[i],
        pawPaint,
        dotPaint,
        scale: i.isEven ? 1 : 0.82,
        angle: i.isEven ? -0.18 : 0.22,
      );
    }
  }

  void _drawPaw(
    Canvas canvas,
    Offset center,
    Paint pawPaint,
    Paint dotPaint, {
    required double scale,
    required double angle,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.scale(scale);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 24.w, height: 20.h),
      pawPaint,
    );
    canvas.drawCircle(Offset(-11.w, -13.h), 4.5.r, dotPaint);
    canvas.drawCircle(Offset(-3.w, -17.h), 4.5.r, dotPaint);
    canvas.drawCircle(Offset(6.w, -16.h), 4.5.r, dotPaint);
    canvas.drawCircle(Offset(13.w, -10.h), 4.r, dotPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ChatBgPainter oldDelegate) => false;
}
