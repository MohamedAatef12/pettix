import 'package:pettix/features/home/domain/entities/report_reason_entity.dart';

class ReportReasonModel extends ReportReasonEntity{
  const ReportReasonModel(
      {
        required super.id,
        required super.name
      }
      );
  factory ReportReasonModel.fromJson(Map<String, dynamic> json) {
    return ReportReasonModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
  ReportReasonModel.fromEntity(ReportReasonEntity entity)
      : super(
    id: entity.id,
    name: entity.name,
  );
  ReportReasonEntity toEntity(ReportReasonModel model) => ReportReasonEntity(
    id: model.id,
    name: model.name,
  );
}