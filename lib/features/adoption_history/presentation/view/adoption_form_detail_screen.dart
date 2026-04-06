import 'package:flutter/material.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
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
      body: AdoptionFormDetailBody(form: form, isOwnerView: isOwnerView),
    );
  }
}
