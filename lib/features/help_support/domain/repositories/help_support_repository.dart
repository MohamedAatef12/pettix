import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/help_support/domain/entities/contact_support_entity.dart';
import 'package:pettix/features/help_support/domain/entities/feedback_entity.dart';
import 'package:pettix/features/help_support/domain/entities/problem_report_entity.dart';

abstract class HelpSupportRepository {
  Future<Either<Failure, void>> submitFeedback(FeedbackEntity feedback);

  Future<Either<Failure, void>> submitProblemReport(
    ProblemReportEntity problemReport,
  );

  Future<Either<Failure, void>> submitContactSupport(
    ContactSupportEntity contactSupport,
  );
}
