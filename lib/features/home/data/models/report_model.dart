import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  const ReportModel({
    required super.id,
    required super.postId,
    required super.author,
    required super.reasonName,
    required super.customReason,
    required super.creationDate,
  });
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as int,
      postId: json['postId'] as int,
      reasonName: json['reasonName'] as String,
      customReason: json['customReason'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
      author: AuthorModel.fromJson(json['author']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'reasonName': reasonName,
      'customReason': customReason,
      'creationDate': creationDate.toIso8601String(),
      'author': (author as AuthorModel).toJson(),
    };
  }
  ReportModel.fromEntity(ReportEntity entity)
    : super(
        id: entity.id,
        postId: entity.postId,
        reasonName: entity.reasonName,
        customReason: entity.customReason,
        creationDate: entity.creationDate,
        author: entity.author,
      );
  ReportEntity toEntity(ReportModel model) => ReportEntity(
    id: model.id,
    postId: model.postId,
    reasonName: model.reasonName,
    customReason: model.customReason,
    creationDate: model.creationDate,
    author: model.author,
  );
}
