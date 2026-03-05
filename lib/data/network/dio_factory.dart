import 'package:dio/dio.dart';
import 'package:talker/talker.dart';

import 'interceptors.dart';

class DioFactory {
  Dio createDio(Talker talker) {
    final dio = Dio()
      ..options = BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      );
    
    // Add interceptors after dio is created so TokenInterceptor can use it
    dio.interceptors.addAll(DioInterceptors.getInterceptors(talker, dio));

    return dio;
  }
}
