import 'package:pettix/features/home/domain/entities/add_report_entity.dart';

class AddReportModel extends AddReportEntity {
  const AddReportModel({
    required super.postId,
    required super.reasonId,
    required super.customReason,
  });
factory AddReportModel.fromJson(Map<String, dynamic> json) {
    return AddReportModel(
      postId: json['post_id'] as int,
      reasonId: json['reason_id'] as int,
      customReason: json['custom_reason'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'reason_id': reasonId,
      'custom_reason': customReason,
    };
  }
  AddReportModel.fromEntity(AddReportEntity entity)
    : super(
        postId: entity.postId,
        reasonId: entity.reasonId,
        customReason: entity.customReason,
      );
  AddReportEntity toEntity(AddReportModel model) => AddReportEntity(
    postId: model.postId,
    reasonId: model.reasonId,
    customReason: model.customReason,
  );
}
