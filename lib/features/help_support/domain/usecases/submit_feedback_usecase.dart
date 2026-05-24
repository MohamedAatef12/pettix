import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/help_support/domain/entities/feedback_entity.dart';
import 'package:pettix/features/help_support/domain/repositories/help_support_repository.dart';

@injectable
class SubmitFeedbackUseCase extends ParamUseCase<void, FeedbackEntity> {
  final HelpSupportRepository _repository;

  SubmitFeedbackUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(FeedbackEntity param) =>
      _repository.submitFeedback(param);
}
