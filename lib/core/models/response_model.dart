import 'package:equatable/equatable.dart';

class ResponseEntity extends Equatable{
  final bool success;
  final String message;
  final String traceId;
  final dynamic result;
  const ResponseEntity({
    required this.success,
    required this.message,
    required this.traceId,
    this.result,
  });

  @override
  List<Object?> get props => [success, message, traceId, result];
}
class ResponseModel extends ResponseEntity{
  const ResponseModel({
    required super.success,
    required super.message,
    required super.traceId,
    super.result,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      traceId: json['traceId'] as String? ?? '',
      result: json['result'],
    );
  }

}