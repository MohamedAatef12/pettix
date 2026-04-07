import 'package:dio/dio.dart';
import 'package:pettix/data/network/dio_interceptor.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class DioInterceptors {
  static List<Interceptor> getInterceptors(Talker talker, Dio dio) {
    return List.unmodifiable([
      // Token interceptor must come first to add auth headers
      TokenInterceptor(dio, talker),
      
      // Logger comes after to log the complete request with headers
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestData: true,
          printResponseData: true,
        ),
      ),
      
      // General error handler
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          talker.handle(e);
          return handler.next(e);
        },
      ),
    ]);
  }
}
