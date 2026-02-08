import 'package:equatable/equatable.dart';

class ReportReasonEntity extends Equatable {
  final int id;
  final String name;

  const ReportReasonEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
