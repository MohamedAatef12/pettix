import 'package:equatable/equatable.dart';

/// Generic id/name lookup entity used for categories, colors, and medicals.
class LookupEntity extends Equatable {
  final int id;
  final String name;

  const LookupEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

/// Aggregates the three pet option lookup lists returned by the API.
class PetOptionsEntity extends Equatable {
  final List<LookupEntity> categories;
  final List<LookupEntity> colors;
  final List<LookupEntity> medicals;

  const PetOptionsEntity({
    required this.categories,
    required this.colors,
    required this.medicals,
  });

  @override
  List<Object?> get props => [categories, colors, medicals];
}
