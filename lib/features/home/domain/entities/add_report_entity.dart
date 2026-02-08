import 'package:equatable/equatable.dart';

class AddReportEntity extends Equatable {
  final int postId;
  final int reasonId;
  final String customReason;


  const AddReportEntity({
    required this.postId,
    required this.reasonId,
    required this.customReason,
  });

  @override
  List<Object?> get props => [postId, reasonId, customReason];
}
