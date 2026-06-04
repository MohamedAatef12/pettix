import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/help_support/data/datasources/help_support_remote_data_source.dart';
import 'package:pettix/features/help_support/data/models/feedback_request_model.dart';
import 'package:pettix/features/help_support/domain/entities/feedback_entity.dart';
import 'package:pettix/features/help_support/domain/repositories/help_support_repository.dart';

@LazySingleton(as: HelpSupportRepository)
class HelpSupportRepositoryImpl implements HelpSupportRepository {
  final HelpSupportRemoteDataSource _remoteDataSource;

  HelpSupportRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> submitFeedback(FeedbackEntity feedback) {
    return _remoteDataSource.submitFeedback(
      FeedbackRequestModel.fromEntity(feedback),
    );
  }
}
