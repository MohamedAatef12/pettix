import 'package:pettix/features/profile/presentation/widgets/profile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/auth_toast.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/my_pets/presentation/widgets/pets_section.dart';
import 'package:pettix/features/profile/domain/entities/update_profile_entity.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_event.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_state.dart';
import 'package:pettix/features/profile/presentation/widgets/address_map_picker.dart';
import 'package:pettix/features/profile/presentation/widgets/avatar_picker.dart';
import 'package:pettix/features/profile/presentation/widgets/profile_header.dart';
import 'package:pettix/features/profile/presentation/widgets/profile_info_card.dart';

class ProfileBody extends StatefulWidget {
  final bool isCurrentUser;
  final int? userId;
  const ProfileBody({super.key, this.isCurrentUser = true, this.userId});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  bool _isEditing = false;

  void _startEditing() {
    context.read<ProfileBloc>().add(InitEditFormEvent());
    setState(() => _isEditing = true);
  }

  void _cancelEditing() {
    setState(() => _isEditing = false);
  }

  void _submit(BuildContext context, ProfileState state) {
    if (state.status == ProfileStatus.updating) return;

    final bloc = context.read<ProfileBloc>();
    final profile = state.profile;
    if (profile == null) return;

    final phone = bloc.phoneController.text.trim();
    bloc.add(
      UpdateProfileEvent(
        UpdateProfileEntity(
          id: profile.id,
          nameEn: bloc.nameEnController.text.trim(),
          nameAr: bloc.nameArController.text.trim(),
          phone: phone.isEmpty ? null : phone,
          age: int.tryParse(bloc.ageController.text.trim()),
          address: bloc.addressController.text.trim(),
          genderId: state.selectedGenderId,
          contactTypeId: profile.contactTypeId,
          statusId: profile.statusId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (!_isEditing) return;
        if (state.status == ProfileStatus.success) {
          AuthToast.showSuccess(context, AppText.profileUpdated);
          setState(() => _isEditing = false);
        }
        if (state.status == ProfileStatus.error) {
          AuthToast.showError(context, state.errorMessage ?? AppText.error);
        }
      },
      builder: (context, state) {
        if (state.status == ProfileStatus.loading ||
            state.status == ProfileStatus.initial) {
          return const ProfileShimmer();
        }
        if (state.status == ProfileStatus.error && state.profile == null) {
          return Center(child: Text(state.errorMessage ?? AppText.error));
        }
        final profile = state.profile;
        if (profile == null) {
          return const ProfileShimmer();
        }
        return _ProfileContent(
          profile: profile,
          isCurrentUser: widget.isCurrentUser,
          userId: widget.userId,
          isEditing: _isEditing,
          state: state,
          onEditTap: _startEditing,
          onCancelEdit: _cancelEditing,
          onSubmit: () => _submit(context, state),
        );
      },
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserEntity profile;
  final bool isCurrentUser;
  final int? userId;
  final bool isEditing;
  final ProfileState state;
  final VoidCallback onEditTap;
  final VoidCallback onCancelEdit;
  final VoidCallback onSubmit;
  const _ProfileContent({
    required this.profile,
    required this.isCurrentUser,
    required this.isEditing,
    required this.state,
    required this.onEditTap,
    required this.onCancelEdit,
    required this.onSubmit,
    this.userId,
  });

  String _genderLabel(int? id) {
    if (id == 1) return AppText.male;
    if (id == 2) return AppText.female;
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _EditTopBar(
          isVisible: isEditing,
          isUpdating: state.status == ProfileStatus.updating,
          onCancel: onCancelEdit,
          onSave: onSubmit,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                isEditing
                    ? _EditableProfileHeader(profile: profile)
                    : Column(
                      children: [
                        ProfileHeader(
                          profile: profile,
                          onEditTap: isCurrentUser ? onEditTap : null,
                        ),
                        ProfileNameSection(profile: profile),
                      ],
                    ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child:
                      isEditing
                          ? _EditableProfileForm(profile: profile)
                          : _ReadOnlyProfileInfo(
                            profile: profile,
                            genderLabel: _genderLabel(profile.genderId),
                            isCurrentUser: isCurrentUser,
                            userId: userId,
                          ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EditTopBar extends StatelessWidget {
  final bool isVisible;
  final bool isUpdating;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _EditTopBar({
    required this.isVisible,
    required this.isUpdating,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: Container(
        height: 52.h,
        padding: EdgeInsetsDirectional.only(start: 4.w, end: 8.w),
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: AppText.cancel,
              onPressed: isUpdating ? null : onCancel,
              icon: AppIcon.raw(
                Icons.close_rounded,
                color: AppColors.current.midGray,
                size: 20.w,
              ),
            ),
            Expanded(
              child: _TypewriterText(
                text: AppText.editProfile,
                style: AppTextStyles.appbar.copyWith(
                  color: AppColors.current.text,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _SaveActionButton(isUpdating: isUpdating, onPressed: onSave),
          ],
        ),
      ),
    );
  }
}

class _TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _TypewriterText({required this.text, required this.style});

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _start();
  }

  @override
  void didUpdateWidget(covariant _TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _start();
    }
  }

  void _start() {
    final milliseconds = (widget.text.length * 24).clamp(140, 360);
    _controller
      ..duration = Duration(milliseconds: milliseconds)
      ..forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final visibleCount = (widget.text.length * _controller.value).ceil();
        return Text(
          widget.text.substring(0, visibleCount),
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: widget.style,
        );
      },
    );
  }
}

class _SaveActionButton extends StatelessWidget {
  final bool isUpdating;
  final VoidCallback onPressed;

  const _SaveActionButton({required this.isUpdating, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUpdating ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOutCubic,
        width: isUpdating ? 42.w : 78.w,
        height: 38.h,
        decoration: BoxDecoration(
          color:
              isUpdating
                  ? AppColors.current.primary.withAlpha(150)
                  : AppColors.current.primary,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Center(
          child:
              isUpdating
                  ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                  : Text(
                    AppText.save,
                    style: AppTextStyles.bold.copyWith(
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                  ),
        ),
      ),
    );
  }
}

class _EditableProfileHeader extends StatelessWidget {
  final UserEntity profile;

  const _EditableProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        AvatarPicker(currentAvatarUrl: profile.avatar),
        SizedBox(height: 12.h),
        Text(
          profile.email,
          style: AppTextStyles.smallDescription.copyWith(
            color: AppColors.current.midGray,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyProfileInfo extends StatelessWidget {
  final UserEntity profile;
  final String genderLabel;
  final bool isCurrentUser;
  final int? userId;

  const _ReadOnlyProfileInfo({
    required this.profile,
    required this.genderLabel,
    required this.isCurrentUser,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(AppText.personalInfo),
        SizedBox(height: 8.h),
        ProfileInfoGroup(
          rows: [
            ProfileInfoRow(
              icon: Icons.person_outline_rounded,
              label: AppText.fullName,
              value: profile.nameEn ?? profile.userName,
            ),
            ProfileInfoRow(
              icon: Icons.email_outlined,
              label: AppText.email,
              value: profile.email,
              iconColor: const Color(0xFF5EA8DF),
            ),
            ProfileInfoRow(
              icon: Icons.phone_outlined,
              label: AppText.phone,
              value: profile.phone ?? '-',
              iconColor: const Color(0xFF56C590),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _SectionLabel(AppText.details),
        SizedBox(height: 8.h),
        ProfileInfoGroup(
          rows: [
            ProfileInfoRow(
              icon: Icons.cake_outlined,
              label: AppText.age,
              value: profile.age?.toString() ?? '-',
              iconColor: const Color(0xFFE8A838),
            ),
            ProfileInfoRow(
              icon: Icons.wc_rounded,
              label: AppText.gender,
              value: genderLabel,
              iconColor: const Color(0xFF3AAFA9),
            ),
            ProfileInfoRow(
              icon: Icons.location_on_outlined,
              label: AppText.address,
              value: profile.address ?? '-',
              iconColor: AppColors.current.red,
            ),
          ],
        ),
        SizedBox(height: 24.h),
        _SectionLabel(isCurrentUser ? AppText.myPets : AppText.pets),
        SizedBox(height: 8.h),
        PetsSection(isCurrentUser: isCurrentUser, userId: userId),
        SizedBox(height: 32.h),
      ],
    );
  }
}

class _EditableProfileForm extends StatelessWidget {
  final UserEntity profile;

  const _EditableProfileForm({required this.profile});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProfileBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(AppText.personalInfo),
        SizedBox(height: 8.h),
        _InlineInfoGroup(
          children: [
            _InlineEditableRow(
              controller: bloc.nameEnController,
              label: AppText.fullName,
              icon: Icons.person_outline_rounded,
              iconColor: AppColors.current.primary,
            ),
            _InlineReadOnlyRow(
              value: profile.email,
              label: AppText.email,
              icon: Icons.email_outlined,
              iconColor: const Color(0xFF5EA8DF),
            ),
            _InlineEditableRow(
              controller: bloc.phoneController,
              label: AppText.phone,
              icon: Icons.phone_outlined,
              iconColor: const Color(0xFF56C590),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _SectionLabel(AppText.details),
        SizedBox(height: 8.h),
        _InlineInfoGroup(
          children: [
            _InlineEditableRow(
              controller: bloc.ageController,
              label: AppText.age,
              icon: Icons.cake_outlined,
              iconColor: const Color(0xFFE8A838),
              keyboardType: TextInputType.number,
            ),
            const _InlineGenderRow(),
            _InlineAddressRow(
              controller: bloc.addressController,
              onTap: () async {
                final picked = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder:
                        (_) => AddressMapPickerPage(
                          initialAddress: bloc.addressController.text,
                        ),
                  ),
                );
                if (!context.mounted) return;
                if (picked != null && picked.isNotEmpty) {
                  bloc.addressController.text = picked;
                }
              },
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

class _InlineInfoGroup extends StatelessWidget {
  final List<Widget> children;

  const _InlineInfoGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.text.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: children.length,
        separatorBuilder:
            (_, __) => Divider(
              height: 1,
              indent: 52.w,
              color: AppColors.current.lightGray,
            ),
        itemBuilder: (_, index) => children[index],
      ),
    );
  }
}

class _InlineEditableRow extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Color iconColor;
  final TextInputType? keyboardType;

  const _InlineEditableRow({
    required this.controller,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return _InlineRowShell(
      icon: icon,
      iconColor: iconColor,
      label: label,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        minLines: 1,
        maxLines: label == AppText.address ? 2 : 1,
        style: AppTextStyles.description.copyWith(
          color: AppColors.current.text,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        decoration: _inlineInputDecoration(),
        cursorColor: AppColors.current.primary,
      ),
    );
  }
}

class _InlineReadOnlyRow extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;

  const _InlineReadOnlyRow({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return _InlineRowShell(
      icon: icon,
      iconColor: iconColor,
      label: label,
      child: Text(
        value,
        style: AppTextStyles.description.copyWith(
          color: AppColors.current.midGray,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InlineGenderRow extends StatelessWidget {
  const _InlineGenderRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (prev, curr) => prev.selectedGenderId != curr.selectedGenderId,
      builder: (context, state) {
        return _InlineRowShell(
          icon: Icons.wc_rounded,
          iconColor: const Color(0xFF3AAFA9),
          label: AppText.gender,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: state.selectedGenderId,
              isExpanded: true,
              icon: AppIcon.raw(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.current.midGray,
                size: 20.w,
              ),
              dropdownColor: AppColors.current.white,
              style: AppTextStyles.description.copyWith(
                color: AppColors.current.text,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              onChanged:
                  (value) =>
                      context.read<ProfileBloc>().add(UpdateGenderEvent(value)),
              items: [
                DropdownMenuItem(value: 1, child: Text(AppText.male)),
                DropdownMenuItem(value: 2, child: Text(AppText.female)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InlineAddressRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const _InlineAddressRow({required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _InlineRowShell(
      icon: Icons.location_on_outlined,
      iconColor: AppColors.current.red,
      label: AppText.address,
      trailing: AppIcon.raw(
        Icons.map_outlined,
        color: AppColors.current.primary,
        size: 18.w,
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        minLines: 1,
        maxLines: 2,
        onTap: onTap,
        style: AppTextStyles.description.copyWith(
          color: AppColors.current.text,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        decoration: _inlineInputDecoration(),
        cursorColor: AppColors.current.primary,
      ),
    );
  }
}

class _InlineRowShell extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Widget child;
  final Widget? trailing;

  const _InlineRowShell({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: AppIcon.raw(icon, color: iconColor, size: 16.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.smallDescription.copyWith(
                    color: AppColors.current.midGray,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                child,
              ],
            ),
          ),
          if (trailing != null) ...[SizedBox(width: 8.w), trailing!],
        ],
      ),
    );
  }
}

InputDecoration _inlineInputDecoration() {
  return const InputDecoration(
    isDense: true,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    contentPadding: EdgeInsets.zero,
  );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.smallDescription.copyWith(
        color: AppColors.current.midGray,
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}
