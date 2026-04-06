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

  const AdoptionHistoryState({
    this.clientStatus = AdoptionHistoryStatus.initial,
    this.ownerStatus = AdoptionHistoryStatus.initial,
    this.clientForms = const [],
    this.ownerForms = const [],
    this.clientError,
    this.ownerError,
  });

  AdoptionHistoryState copyWith({
    AdoptionHistoryStatus? clientStatus,
    AdoptionHistoryStatus? ownerStatus,
    List<AdoptionFormEntity>? clientForms,
    List<AdoptionFormEntity>? ownerForms,
    String? clientError,
    String? ownerError,
  }) {
    return AdoptionHistoryState(
      clientStatus: clientStatus ?? this.clientStatus,
      ownerStatus: ownerStatus ?? this.ownerStatus,
      clientForms: clientForms ?? this.clientForms,
      ownerForms: ownerForms ?? this.ownerForms,
      clientError: clientError,
      ownerError: ownerError,
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
      ];
}
