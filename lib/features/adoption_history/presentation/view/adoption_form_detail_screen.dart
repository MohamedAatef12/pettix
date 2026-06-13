import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/pet_toast.dart';
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
            (previous, current) =>
                previous.updatedFormId != current.updatedFormId ||
                previous.updatedStatus != current.updatedStatus,
        listener: (context, state) {
          if (state.updatedFormId == form.id) {
            PetToast.showSuccess(context, AppText.statusUpdatedSuccessfully);
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<AdoptionHistoryBloc, AdoptionHistoryState>(
          buildWhen:
              (previous, current) =>
                  previous.ownerForms != current.ownerForms ||
                  previous.updatedFormId != current.updatedFormId ||
                  previous.updatedStatus != current.updatedStatus,
          builder: (context, state) {
            final latestForm = state.ownerForms
                .cast<AdoptionFormEntity>()
                .firstWhere(
                  (item) => item.id == form.id,
                  orElse:
                      () =>
                          state.updatedFormId == form.id &&
                                  state.updatedStatus != null
                              ? _copyFormWithStatus(form, state.updatedStatus!)
                              : form,
                );

            return AdoptionFormDetailBody(
              form: latestForm,
              isOwnerView: isOwnerView,
            );
          },
        ),
      ),
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
}
