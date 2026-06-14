import 'package:equatable/equatable.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';

enum AdoptionHistoryStatus { initial, loading, loaded, error }

class AdoptionHistoryState extends Equatable {
  final AdoptionHistoryStatus clientStatus;
  final AdoptionHistoryStatus ownerStatus;
  final List<AdoptionFormEntity> clientForms;
  final List<AdoptionFormEntity> ownerForms;
  final String? clientError;
  final String? ownerError;
  final int? updatedFormId;
  final int? updatedStatus;

  const AdoptionHistoryState({
    this.clientStatus = AdoptionHistoryStatus.initial,
    this.ownerStatus = AdoptionHistoryStatus.initial,
    this.clientForms = const [],
    this.ownerForms = const [],
    this.clientError,
    this.ownerError,
    this.updatedFormId,
    this.updatedStatus,
  });

  AdoptionHistoryState copyWith({
    AdoptionHistoryStatus? clientStatus,
    AdoptionHistoryStatus? ownerStatus,
    List<AdoptionFormEntity>? clientForms,
    List<AdoptionFormEntity>? ownerForms,
    String? clientError,
    String? ownerError,
    int? updatedFormId,
    int? updatedStatus,
  }) {
    return AdoptionHistoryState(
      clientStatus: clientStatus ?? this.clientStatus,
      ownerStatus: ownerStatus ?? this.ownerStatus,
      clientForms: clientForms ?? this.clientForms,
      ownerForms: ownerForms ?? this.ownerForms,
      clientError: clientError ?? this.clientError,
      ownerError: ownerError ?? this.ownerError,
      updatedFormId: updatedFormId ?? this.updatedFormId,
      updatedStatus: updatedStatus ?? this.updatedStatus,
    );
  }

  @override
  List<Object?> get props => [
    clientStatus,
    ownerStatus,
    clientForms,
    ownerForms,
    clientError,
    ownerError,
    updatedFormId,
    updatedStatus,
  ];
}
