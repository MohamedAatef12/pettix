import 'package:injectable/injectable.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/api_services.dart';
import 'package:pettix/data/network/constants.dart';
import '../model/notification_response.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationResponse> getNotifications({
    required int pageIndex,
    required int pageSize,
    int? notificationTypeId,
  });

  Future<NotificationResponse> markAllAsRead({required int notificationTypeId});

  Future<NotificationResponse> markAsRead({required int id});

  Future<NotificationResponse> sendNotification({
    required int userId,
    required String title,
    required String body,
    required int sentBy,
    required int notificationTypeId,
    String? fireBaseToken,
    String? correlationId,
  });
}

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiService _apiService;

  NotificationRemoteDataSourceImpl(this._apiService);

  @override
  Future<NotificationResponse> getNotifications({
    required int pageIndex,
    required int pageSize,
    int? notificationTypeId,
  }) async {
    final userToken = await DI.find<ICacheManager>().getToken();

    final queryParams = {
      'PageIndex': pageIndex < 1 ? 1 : pageIndex,
      'PageSize': pageSize,
    };
    if (notificationTypeId != null) {
      queryParams['notificationTypeId'] = notificationTypeId;
    }

    final response = await _apiService.get(
      endPoint: Constants.notificationSearchEndpoint,
      queryParameters: queryParams,
      headers:
          userToken != null ? {'Authorization': 'Bearer $userToken'} : null,
    );

    return NotificationResponse(
      success: response.success,
      message: response.message,
      traceId: response.traceId,
      result:
          response.result != null
              ? NotificationResult.fromJson(
                response.result as Map<String, dynamic>,
              )
              : null,
    );
  }

  @override
  Future<NotificationResponse> markAllAsRead({
    required int notificationTypeId,
  }) async {
    final userToken = await DI.find<ICacheManager>().getToken();

    final response = await _apiService.put(
      endPoint: Constants.readAllNotificationsEndpoint,
      queryParameters: {'notificationTypeId': notificationTypeId},
      headers:
          userToken != null ? {'Authorization': 'Bearer $userToken'} : null,
    );

    return NotificationResponse(
      success: response.success,
      message: response.message,
      traceId: response.traceId,
      result:
          response.result != null
              ? NotificationResult.fromJson(
                response.result as Map<String, dynamic>,
              )
              : null,
    );
  }

  @override
  Future<NotificationResponse> markAsRead({required int id}) async {
    final userToken = await DI.find<ICacheManager>().getToken();

    final response = await _apiService.put(
      endPoint: Constants.readSingleNotificationEndpoint.replaceAll(
        'param',
        id.toString(),
      ),
      headers:
          userToken != null ? {'Authorization': 'Bearer $userToken'} : null,
    );

    return NotificationResponse(
      success: response.success,
      message: response.message,
      traceId: response.traceId,
      result:
          response.result != null
              ? NotificationResult.fromJson(
                response.result as Map<String, dynamic>,
              )
              : null,
    );
  }

  @override
  Future<NotificationResponse> sendNotification({
    required int userId,
    required String title,
    required String body,
    required int sentBy,
    required int notificationTypeId,
    String? fireBaseToken,
    String? correlationId,
  }) async {
    final userToken = await DI.find<ICacheManager>().getToken();

    final response = await _apiService.post(
      endPoint: Constants.sendNotificationEndpoint,
      data: {
        "userId": userId,
        "fireBaseToken": fireBaseToken ?? "",
        "title": title,
        "body": body,
        "sentBy": sentBy,
        "notificationTypeId": notificationTypeId,
        "correlationId": correlationId ?? "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      },
      headers:
          userToken != null ? {'Authorization': 'Bearer $userToken'} : null,
    );

    return NotificationResponse(
      success: response.success,
      message: response.message,
      traceId: response.traceId,
      result: null,
    );
  }
}
