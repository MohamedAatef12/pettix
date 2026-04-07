import 'notification_model.dart';

class NotificationResult {
  final int pageIndex;
  final int pageSize;
  final int count;
  final List<NotificationModel> data;

  NotificationResult({
    required this.pageIndex,
    required this.pageSize,
    required this.count,
    required this.data,
  });

  factory NotificationResult.fromJson(Map<String, dynamic> json) {
    return NotificationResult(
      pageIndex: json['pageIndex'] as int? ?? 0,
      pageSize: json['pageSize'] as int? ?? 0,
      count: json['count'] as int? ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class NotificationResponse {
  final bool success;
  final String message;
  final String traceId;
  final NotificationResult? result;

  NotificationResponse({
    required this.success,
    required this.message,
    required this.traceId,
    this.result,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      traceId: json['traceId'] as String? ?? '',
      result: json['result'] != null
          ? NotificationResult.fromJson(json['result'] as Map<String, dynamic>)
          : null,
    );
  }
}
