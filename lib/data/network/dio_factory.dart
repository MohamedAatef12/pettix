import 'package:dio/dio.dart';
import 'package:talker/talker.dart';

import 'constants.dart';
import 'interceptors.dart';

class DioFactory {
  Dio createDio(Talker talker) {
    final dio = Dio()
      ..options = BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
    
    // Add interceptors after dio is created so TokenInterceptor can use it
    dio.interceptors.addAll(DioInterceptors.getInterceptors(talker, dio));

    return dio;
  }
}
