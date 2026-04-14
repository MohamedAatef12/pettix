import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_bloc.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_state.dart';
import 'package:pettix/features/adoption_history/presentation/widgets/adoption_form_detail_body.dart';

import '../../../../core/themes/app_colors.dart';

/// Receives [AdoptionFormEntity] and [isOwnerView] via GoRouter extra map.
class AdoptionFormDetailScreen extends StatelessWidget {
  final AdoptionFormEntity form;
  final bool isOwnerView;

  const AdoptionFormDetailScreen({
    super.key,
    required this.form,
    required this.isOwnerView,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: BlocListener<AdoptionHistoryBloc, AdoptionHistoryState>(
        listenWhen:
            (previous, current) => previous.ownerStatus != current.ownerStatus,
        listener: (context, state) {
          if (state.ownerStatus == AdoptionHistoryStatus.loading) {
            // Optional: Show loading dialog or overlay
          } else if (state.ownerStatus == AdoptionHistoryStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.ownerError ?? 'An error occurred'),
                backgroundColor: AppColors.current.red,
              ),
            );
          } else if (state.ownerStatus == AdoptionHistoryStatus.loaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Status updated successfully'),
                backgroundColor: AppColors.current.green,
              ),
            );
            Navigator.of(context).pop();
          }
        },
        child: AdoptionFormDetailBody(form: form, isOwnerView: isOwnerView),
      ),
    );
  }
}
