import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/lookup_entity.dart';
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
                    onRemove: () => context
                        .read<MyPetsBloc>()
                        .add(RemoveVaccinationEvent(entry.key)),
                  ),
                ),
            SizedBox(height: 8.h),
            _AddVaccinationButton(medicals: state.medicals),
          ],
        );
      },
    );
  }
}

class _VaccinationChip extends StatelessWidget {
  final VaccinationEntity vaccination;
  final VoidCallback onRemove;

  const _VaccinationChip({
    required this.vaccination,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final date = vaccination.vaccinationDate;
    final dateLabel = date != null
        ? '${date.day}/${date.month}/${date.year}'
        : '';

    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.current.teal.withAlpha(20),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.current.teal.withAlpha(60)),
      ),
      child: Row(
        children: [
          Icon(Icons.vaccines_rounded,
              color: AppColors.current.teal, size: 16.w),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccination.name,
                  style: TextStyle(
                    color: AppColors.current.text,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (dateLabel.isNotEmpty)
                  Text(
                    dateLabel,
                    style: TextStyle(
                      color: AppColors.current.midGray,
                      fontSize: 10.sp,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close_rounded,
                color: AppColors.current.midGray, size: 16.w),
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
    return GestureDetector(
      onTap: () => _showVaccinationSheet(context, medicals),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.current.primary.withAlpha(80),
            width: 1.5,
          ),
          color: AppColors.current.lightBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: AppColors.current.primary, size: 18.w),
            SizedBox(width: 6.w),
            Text(
              'Add Vaccination',
              style: TextStyle(
                color: AppColors.current.primary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet for selecting a vaccination name + date.
void _showVaccinationSheet(BuildContext context, List<LookupEntity> medicals) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _VaccinationSheet(
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      // Combine the chosen date with the current UTC time so we send a full
      // timestamp (e.g. 2026-04-01T14:32:15.000Z) instead of midnight-only.
      // Using DateTime.utc ensures Kind=Utc, which Npgsql requires.
      final now = DateTime.now().toUtc();
      setState(() => _selectedDate = DateTime.utc(
            picked.year,
            picked.month,
            picked.day,
            now.hour,
            now.minute,
            now.second,
          ));
    }
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
        MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ADD VACCINATION',
            style: TextStyle(
              color: AppColors.current.text,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 16.h),
          // Medical option chips
          if (widget.medicals.isNotEmpty) ...[
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: widget.medicals
                  .map(
                    (m) => ChoiceChip(
                      label: Text(m.name,
                          style: TextStyle(fontSize: 11.sp)),
                      selected: _selectedName == m.name,
                      onSelected: (_) =>
                          setState(() => _selectedName = m.name),
                      selectedColor: AppColors.current.primary.withAlpha(40),
                      side: BorderSide(
                        color: _selectedName == m.name
                            ? AppColors.current.primary
                            : AppColors.current.lightGray,
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 12.h),
          ],
          // Custom name field
          TextFormField(
            controller: _customController,
            decoration: InputDecoration(
              labelText: 'Or type a custom name',
              labelStyle: TextStyle(
                  color: AppColors.current.midGray, fontSize: 12.sp),
              filled: true,
              fillColor: AppColors.current.lightBlue,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (_) => setState(() => _selectedName = null),
          ),
          SizedBox(height: 12.h),
          // Date picker
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.current.lightBlue,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      color: AppColors.current.primary, size: 18.w),
                  SizedBox(width: 10.w),
                  Text(
                    _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'Select vaccination date',
                    style: TextStyle(
                      color: _selectedDate != null
                          ? AppColors.current.text
                          : AppColors.current.midGray,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.current.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                'Add',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
