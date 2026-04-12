import 'package:pettix/features/my_pets/domain/entities/lookup_entity.dart';

/// Data model for a generic id/name lookup item (categories, colors, medicals).
class LookupModel extends LookupEntity {
  const LookupModel({required super.id, required super.name});

  factory LookupModel.fromJson(Map<String, dynamic> json) => LookupModel(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
      );
}
