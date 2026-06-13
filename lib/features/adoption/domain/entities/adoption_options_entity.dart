import 'package:equatable/equatable.dart';

class LivingSituationEntity extends Equatable {
  final int id;
  final String name;

  const LivingSituationEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class ResidenceTypeEntity extends Equatable {
  final int id;
  final String name;

  const ResidenceTypeEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class AdoptionOptionsEntity extends Equatable {
  final List<LivingSituationEntity> livingSituations;
  final List<ResidenceTypeEntity> residenceTypes;

  const AdoptionOptionsEntity({
    required this.livingSituations,
    required this.residenceTypes,
  });

  @override
  List<Object?> get props => [livingSituations, residenceTypes];
}
