import '../../domain/entities/adoption_options_entity.dart';

class LivingSituationModel extends LivingSituationEntity {
  const LivingSituationModel({required super.id, required super.name});

  factory LivingSituationModel.fromJson(Map<String, dynamic> json) {
    return LivingSituationModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class ResidenceTypeModel extends ResidenceTypeEntity {
  const ResidenceTypeModel({required super.id, required super.name});

  factory ResidenceTypeModel.fromJson(Map<String, dynamic> json) {
    return ResidenceTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class AdoptionOptionsModel extends AdoptionOptionsEntity {
  const AdoptionOptionsModel({
    required List<LivingSituationModel> super.livingSituations,
    required List<ResidenceTypeModel> super.residenceTypes,
  });

  factory AdoptionOptionsModel.fromJson(Map<String, dynamic> json) {
    return AdoptionOptionsModel(
      livingSituations:
          (json['livingSituations'] as List<dynamic>?)
              ?.map(
                (e) => LivingSituationModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      residenceTypes:
          (json['residenceTypes'] as List<dynamic>?)
              ?.map(
                (e) => ResidenceTypeModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}
