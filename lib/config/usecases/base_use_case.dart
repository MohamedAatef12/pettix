import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';

abstract class ParamUseCase<Output, Params> {
  Future<Either<Failure, Output>> call(Params param);
}

abstract class NoParamUseCase<Output> {
  Future<Either<Failure, Output>> call();
}
