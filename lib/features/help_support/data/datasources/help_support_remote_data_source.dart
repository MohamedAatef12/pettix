import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/api_services.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/help_support/data/models/contact_support_request_model.dart';
import 'package:pettix/features/help_support/data/models/feedback_request_model.dart';
import 'package:pettix/features/help_support/data/models/problem_report_request_model.dart';

abstract class HelpSupportRemoteDataSource {
  Future<Either<Failure, void>> submitFeedback(FeedbackRequestModel request);

  Future<Either<Failure, void>> submitProblemReport(
    ProblemReportRequestModel request,
  );

  Future<Either<Failure, void>> submitContactSupport(
    ContactSupportRequestModel request,
  );
}

@LazySingleton(as: HelpSupportRemoteDataSource)
class HelpSupportRemoteDataSourceImpl implements HelpSupportRemoteDataSource {
  final ApiService _apiService;

  HelpSupportRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, void>> submitFeedback(
    FeedbackRequestModel request,
  ) async {
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

  @override
  Future<Either<Failure, void>> submitProblemReport(
    ProblemReportRequestModel request,
  ) async {
    try {
      final response = await _apiService.post(
        endPoint: Constants.submitProblemReportEndpoint,
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

  @override
  Future<Either<Failure, void>> submitContactSupport(
    ContactSupportRequestModel request,
  ) async {
    try {
      final response = await _apiService.post(
        endPoint: Constants.submitContactSupportEndpoint,
        data: request.toJson(),
        receiveTimeout: const Duration(seconds: 20),
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
