import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/api_services.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/help_support/data/models/feedback_request_model.dart';

abstract class HelpSupportRemoteDataSource {
  Future<Either<Failure, void>> submitFeedback(FeedbackRequestModel request);
}

@LazySingleton(as: HelpSupportRemoteDataSource)
class HelpSupportRemoteDataSourceImpl implements HelpSupportRemoteDataSource {
  final ApiService _apiService;

  HelpSupportRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, void>> submitFeedback(FeedbackRequestModel request) async {
    try {
      final response = await _apiService.post(
        endPoint: Constants.submitFeedbackEndpoint,
        data: request.toJson(),
      );
      if (response.success == true) {
        return const Right(null);
      }
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }
}
