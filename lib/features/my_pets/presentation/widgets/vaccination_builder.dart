import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
import 'package:pettix/features/my_pets/domain/entities/lookup_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_bloc.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_event.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_state.dart';

/// Shows the list of added vaccinations + an "Add Vaccination" button.
class VaccinationBuilder extends StatelessWidget {
  const VaccinationBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPetsBloc, MyPetsState>(
      buildWhen: (prev, curr) => prev.formVaccinations != curr.formVaccinations,
      builder: (context, state) {
        return Column(
          children: [
            ...state.formVaccinations.asMap().entries.map(
              (entry) => _VaccinationChip(
                vaccination: entry.value,
                onRemove:
                    () => context.read<MyPetsBloc>().add(
                      RemoveVaccinationEvent(entry.key),
                    ),
              ),
            ),
            SizedBox(height: state.formVaccinations.isEmpty ? 0 : 8.h),
            _AddVaccinationButton(medicals: state.medicals),
          ],
        );
      },
    );
  }
}

String _formatDateInEnglish(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

class _VaccinationChip extends StatelessWidget {
  final VaccinationEntity vaccination;
  final VoidCallback onRemove;

  const _VaccinationChip({required this.vaccination, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final date = vaccination.vaccinationDate;
    final dateLabel = date != null ? _formatDateInEnglish(date) : '';

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.current.teal.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.current.teal.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.current.teal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: AppIcon.raw(
              Icons.vaccines_rounded,
              color: AppColors.current.teal,
              size: 16.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccination.name,
                  style: TextStyle(
                    color: AppColors.current.text,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (dateLabel.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    dateLabel,
                    style: TextStyle(
                      color: AppColors.current.midGray,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: AppIcon.raw(
                  Icons.close_rounded,
                  color: AppColors.current.midGray,
                  size: 16.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddVaccinationButton extends StatelessWidget {
  final List<LookupEntity> medicals;

  const _AddVaccinationButton({required this.medicals});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showVaccinationSheet(context, medicals),
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 13.h),
          decoration: BoxDecoration(
            color: AppColors.current.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.current.primary.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  color: AppColors.current.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: AppIcon.raw(
                  Icons.add_rounded,
                  color: AppColors.current.primary,
                  size: 14.w,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                AppText.addVaccination,
                style: TextStyle(
                  color: AppColors.current.primary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Vaccination bottom sheet ──────────────────────────────────────────────────

void _showVaccinationSheet(BuildContext context, List<LookupEntity> medicals) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (_) => _VaccinationSheet(
          medicals: medicals,
          onAdd: (v) => context.read<MyPetsBloc>().add(AddVaccinationEvent(v)),
        ),
  );
}

class _VaccinationSheet extends StatefulWidget {
  final List<LookupEntity> medicals;
  final ValueChanged<VaccinationEntity> onAdd;

  const _VaccinationSheet({required this.medicals, required this.onAdd});

  @override
  State<_VaccinationSheet> createState() => _VaccinationSheetState();
}

class _VaccinationSheetState extends State<_VaccinationSheet> {
  String? _selectedName;
  DateTime? _selectedDate;
  final _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _pickDate() {
    DateTime selected = _selectedDate ?? DateTime.now();

    showModalBottomSheet(
      backgroundColor: AppColors.current.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder:
          (_) => Container(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.current.lightGray,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          AppText.cancel,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.current.lightText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        AppText.selectVaccinationDate,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.current.text,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final now = DateTime.now().toUtc();
                          setState(
                            () =>
                                _selectedDate = DateTime.utc(
                                  selected.year,
                                  selected.month,
                                  selected.day,
                                  now.hour,
                                  now.minute,
                                  now.second,
                                ),
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppText.confirm,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.current.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 180.h,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: AppColors.current.lightBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.current.text,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selected,
                      maximumDate: DateTime.now(),
                      minimumDate: DateTime(2000),
                      onDateTimeChanged: (value) {
                        selected = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _submit() {
    final name = _selectedName ?? _customController.text.trim();
    if (name.isEmpty) return;
    widget.onAdd(VaccinationEntity(name: name, vaccinationDate: _selectedDate));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20.w,
        20.h,
        20.w,
        MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.current.lightGray,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AppText.addVaccinationUpper,
            style: TextStyle(
              color: AppColors.current.text,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),
          if (widget.medicals.isNotEmpty) ...[
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children:
                  widget.medicals.map((m) {
                    final selected = _selectedName == m.name;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedName = m.name),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selected
                                  ? AppColors.current.primary
                                  : AppColors.current.lightBlue,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color:
                                selected
                                    ? AppColors.current.primary
                                    : AppColors.current.lightGray,
                          ),
                        ),
                        child: Text(
                          m.name,
                          style: TextStyle(
                            color:
                                selected
                                    ? Colors.white
                                    : AppColors.current.text,
                            fontSize: 12.sp,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(height: 14.h),
          ],
          TextFormField(
            controller: _customController,
            decoration: InputDecoration(
              labelText: AppText.customVaccinationName,
              labelStyle: TextStyle(
                color: AppColors.current.midGray,
                fontSize: 13.sp,
              ),
              filled: true,
              fillColor: AppColors.current.lightBlue,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.current.primary,
                  width: 1.5,
                ),
              ),
            ),
            onChanged: (_) => setState(() => _selectedName = null),
          ),
          SizedBox(height: 10.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12.r),
              child: Ink(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.current.lightBlue,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    AppIcon.raw(
                      Icons.calendar_today_rounded,
                      color: AppColors.current.primary,
                      size: 18.w,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      _selectedDate != null
                          ? _formatDateInEnglish(_selectedDate!)
                          : AppText.selectVaccinationDate,
                      style: TextStyle(
                        color:
                            _selectedDate != null
                                ? AppColors.current.text
                                : AppColors.current.midGray,
                        fontSize: 13.sp,
                      ),
                    ),
                    if (_selectedDate != null) ...[
                      const Spacer(),
                      AppIcon.raw(
                        Icons.check_circle_rounded,
                        color: AppColors.current.teal,
                        size: 16.w,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.current.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                AppText.add,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
