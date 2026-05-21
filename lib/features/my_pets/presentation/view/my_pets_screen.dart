import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_cached_image.dart';
import 'package:pettix/features/my_pets/domain/entities/lookup_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_request_entity.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_bloc.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_event.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_state.dart';
import 'package:shimmer/shimmer.dart';

class MyPetsScreen extends StatelessWidget {
  const MyPetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(
          AppRoutes.addPet,
          extra: context.read<MyPetsBloc>(),
        ),
        backgroundColor: AppColors.current.primary,
        elevation: 4,
        icon: Icon(Icons.add_rounded, color: Colors.white, size: 22.w),
        label: Text(
          'Add New Pet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          _MyPetsHeader(),
          Expanded(
            child: BlocConsumer<MyPetsBloc, MyPetsState>(
              listener: (context, state) {
                if (state.status == MyPetsStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Done!'),
                      backgroundColor: AppColors.current.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  );
                }
                if (state.status == MyPetsStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(state.errorMessage ?? 'An error occurred'),
                      backgroundColor: AppColors.current.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == MyPetsStatus.loading &&
                    state.pets.isEmpty) {
                  return _LoadingList();
                }
                if (state.pets.isEmpty) {
                  return _EmptyView();
                }
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                  itemCount: state.pets.length,
                  itemBuilder: (context, index) {
                    final pet = state.pets[index];
                    return _PetManageCard(
                      pet: pet,
                      onEdit: () =>
                          _showEditSheet(context, pet, state),
                      onDelete: () =>
                          _showDeleteDialog(context, pet),
                      onToggleStatus: (v) =>
                          context.read<MyPetsBloc>().add(
                                UpdatePetStatusEvent(
                                  petId: pet.id,
                                  status: v,
                                ),
                              ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, PetEntity pet) {
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r)),
        title: Text('Delete Pet?',
            style: AppTextStyles.bold.copyWith(fontSize: 18.sp)),
        content: Text(
          'Are you sure you want to permanently delete ${pet.name}?',
          style:
              TextStyle(fontSize: 14.sp, color: AppColors.current.text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(d).pop(),
            child: Text('Cancel',
                style: TextStyle(color: AppColors.current.midGray)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.current.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
            ),
            onPressed: () {
              Navigator.of(d).pop();
              context.read<MyPetsBloc>().add(DeletePetEvent(pet.id));
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(
      BuildContext context, PetEntity pet, MyPetsState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<MyPetsBloc>(),
        child: _EditPetSheet(
          pet: pet,
          categories: state.categories,
          colors: state.colors,
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _MyPetsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 20.h),
          child: SizedBox(
            height: 30.h,
            width: double.infinity,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.goNamed(AppRouteNames.bottomNav);
                      }
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.current.text,
                      size: 20.w,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'My Pets',
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.current.text,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Pet card ─────────────────────────────────────────────────────────────────

class _PetManageCard extends StatelessWidget {
  final PetEntity pet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<int> onToggleStatus;

  const _PetManageCard({
    required this.pet,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = pet.adoptionStatus == 1;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: SizedBox(
                      width: 80.w,
                      height: 80.w,
                      child: AppCachedImage(
                        imageUrl: pet.imageUrls.firstOrNull ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                pet.name,
                                style: AppTextStyles.bold.copyWith(
                                  fontSize: 16.sp,
                                  color: AppColors.current.text,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: isAvailable
                                    ? AppColors.current.teal
                                        .withValues(alpha: 0.12)
                                    : AppColors.current.midGray
                                        .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                isAvailable ? 'Available' : 'Private',
                                style: TextStyle(
                                  color: isAvailable
                                      ? AppColors.current.teal
                                      : AppColors.current.midGray,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          pet.code,
                          style: TextStyle(
                            color: AppColors.current.midGray,
                            fontSize: 10.sp,
                            fontFamily: 'monospace',
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            if (pet.categoryName != null) ...[
                              _Tag(
                                  label: pet.categoryName!,
                                  color: AppColors.current.primary),
                              SizedBox(width: 6.w),
                            ],
                            if (pet.genderName != null)
                              _Tag(
                                label: pet.genderName!,
                                color: const Color(0xFFC8933D),
                                bgColor: const Color(0xFFF7F3ED),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
                height: 1,
                thickness: 1,
                color: AppColors.current.lightGray),
            // Actions row
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  // Available switch
                  Switch.adaptive(
                    value: isAvailable,
                    activeTrackColor:
                        AppColors.current.teal.withValues(alpha: 0.5),
                    activeThumbColor: AppColors.current.teal,
                    onChanged: (v) => onToggleStatus(v ? 1 : 0),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Available',
                    style: TextStyle(
                      color: AppColors.current.text,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  // Edit
                  _ActionBtn(
                    icon: Icons.edit_rounded,
                    color: AppColors.current.primary,
                    onTap: onEdit,
                  ),
                  SizedBox(width: 10.w),
                  // Delete
                  _ActionBtn(
                    icon: Icons.delete_rounded,
                    color: AppColors.current.red,
                    onTap: onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final Color? bgColor;
  const _Tag({required this.label, required this.color, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor ?? color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 10.sp, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 16.w),
      ),
    );
  }
}

// ─── Loading shimmer ──────────────────────────────────────────────────────────

class _LoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      itemCount: 6,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, __) => Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 120.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        )),
                    SizedBox(height: 8.h),
                    Container(
                        width: 80.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        )),
                    SizedBox(height: 12.h),
                    Row(children: [
                      Container(
                          width: 60.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          )),
                      SizedBox(width: 8.w),
                      Container(
                          width: 50.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          )),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pets_rounded,
                size: 64.w, color: AppColors.current.blueGray),
            SizedBox(height: 16.h),
            Text(
              'No Pets Registered Yet',
              style: AppTextStyles.bold.copyWith(
                color: AppColors.current.text,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Tap the button below to register your first pet and make it available for adoption.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.current.midGray,
                fontSize: 13.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Edit bottom sheet ────────────────────────────────────────────────────────

class _EditPetSheet extends StatefulWidget {
  final PetEntity pet;
  final List<LookupEntity> categories;
  final List<LookupEntity> colors;

  const _EditPetSheet({
    required this.pet,
    required this.categories,
    required this.colors,
  });

  @override
  State<_EditPetSheet> createState() => _EditPetSheetState();
}

class _EditPetSheetState extends State<_EditPetSheet> {
  late final TextEditingController _name;
  late final TextEditingController _desc;
  late final TextEditingController _details;
  late final TextEditingController _age;
  int? _catId, _colorId, _genderId;

  LookupEntity? _findById(List<LookupEntity> list, String? name) {
    if (name == null) return null;
    try {
      return list
          .firstWhere((e) => e.name.toLowerCase() == name.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.pet.name);
    _desc = TextEditingController(text: widget.pet.description);
    _details = TextEditingController(text: widget.pet.details);
    _age = TextEditingController(text: widget.pet.age?.toString() ?? '');
    _catId = _findById(widget.categories, widget.pet.categoryName)?.id;
    _colorId = _findById(widget.colors, widget.pet.colorName)?.id;
    final g = widget.pet.genderName?.toLowerCase();
    _genderId = g == 'male' ? 1 : (g == 'female' ? 2 : null);
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _details.dispose();
    _age.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    context.read<MyPetsBloc>().add(UpdatePetEvent(
          widget.pet.id,
          PetRequestEntity(
            name: name,
            description:
                _desc.text.trim().isEmpty ? null : _desc.text.trim(),
            details: _details.text.trim().isEmpty
                ? null
                : _details.text.trim(),
            age: int.tryParse(_age.text.trim()),
            categoryId: _catId,
            genderId: _genderId,
            colorId: _colorId,
          ),
        ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(
          20.w, 16.h, 20.w, MediaQuery.of(context).viewInsets.bottom + 20.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                    color: AppColors.current.lightGray,
                    borderRadius: BorderRadius.circular(2.r)),
              ),
            ),
            SizedBox(height: 16.h),
            Text('Edit Pet Info',
                style: AppTextStyles.bold
                    .copyWith(fontSize: 18.sp, color: AppColors.current.text)),
            SizedBox(height: 20.h),
            _field(_name, 'Pet Name', Icons.pets_rounded,
                AppColors.current.primary),
            SizedBox(height: 12.h),
            _field(_desc, 'Description', Icons.notes_rounded,
                const Color(0xFF7A6FD8),
                maxLines: 3),
            SizedBox(height: 12.h),
            _field(_details, 'Health & Details',
                Icons.health_and_safety_outlined, AppColors.current.teal,
                maxLines: 2),
            SizedBox(height: 12.h),
            _field(_age, 'Age (years)', Icons.cake_outlined,
                const Color(0xFFE8A838),
                type: TextInputType.number),
            SizedBox(height: 12.h),
            _drop<int>(
              label: 'Category',
              icon: Icons.category_outlined,
              iconColor: const Color(0xFF5EA8DF),
              value: _catId,
              items: widget.categories
                  .map((c) =>
                      DropdownMenuItem(value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (v) => setState(() => _catId = v),
            ),
            SizedBox(height: 12.h),
            _drop<int>(
              label: 'Gender',
              icon: Icons.wc_rounded,
              iconColor: const Color(0xFF3AAFA9),
              value: _genderId,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Male')),
                DropdownMenuItem(value: 2, child: Text('Female')),
              ],
              onChanged: (v) => setState(() => _genderId = v),
            ),
            SizedBox(height: 12.h),
            _drop<int>(
              label: 'Color',
              icon: Icons.palette_outlined,
              iconColor: AppColors.current.brown,
              value: _colorId,
              items: widget.colors
                  .map((c) =>
                      DropdownMenuItem(value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (v) => setState(() => _colorId = v),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: _submit,
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.current.primary,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                alignment: Alignment.center,
                child: Text('Save Changes',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon,
    Color iconColor, {
    int maxLines = 1,
    TextInputType? type,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: type,
        style: TextStyle(
            color: AppColors.current.text,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: AppColors.current.midGray, fontSize: 13.sp),
          prefixIcon: Icon(icon, color: iconColor, size: 20.w),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _drop<T>({
    required String label,
    required IconData icon,
    required Color iconColor,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          hint: Row(children: [
            Icon(icon, color: iconColor, size: 20.w),
            SizedBox(width: 12.w),
            Text(label,
                style: TextStyle(
                    color: AppColors.current.midGray, fontSize: 13.sp)),
          ]),
          icon: Icon(Icons.expand_more_rounded,
              color: AppColors.current.midGray, size: 20.w),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
