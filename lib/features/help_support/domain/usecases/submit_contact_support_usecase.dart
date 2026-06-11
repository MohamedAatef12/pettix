import 'package:dartz/dartz.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/help_support/domain/entities/contact_support_entity.dart';
import 'package:pettix/features/help_support/domain/repositories/help_support_repository.dart';

class SubmitContactSupportUseCase
    extends ParamUseCase<void, ContactSupportEntity> {
  final HelpSupportRepository _repository;

  SubmitContactSupportUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ContactSupportEntity param) {
    return _repository.submitContactSupport(param);
  }
}
