import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/help_support/domain/entities/feedback_entity.dart';

abstract class HelpSupportRepository {
  Future<Either<Failure, void>> submitFeedback(FeedbackEntity feedback);
}
