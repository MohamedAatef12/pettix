import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/auth_toast.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_bloc.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_state.dart';
import 'package:pettix/features/adoption_history/presentation/widgets/adoption_form_detail_body.dart';

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
            AuthToast.showError(
              context,
              state.ownerError ?? AppText.anErrorOccurred,
            );
          } else if (state.ownerStatus == AdoptionHistoryStatus.loaded) {
            AuthToast.showSuccess(context, AppText.statusUpdatedSuccessfully);
            Navigator.of(context).pop();
          }
        },
        child: AdoptionFormDetailBody(form: form, isOwnerView: isOwnerView),
      ),
    );
  }
}
