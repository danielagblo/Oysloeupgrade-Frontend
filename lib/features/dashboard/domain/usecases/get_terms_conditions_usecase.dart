import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/terms_condition_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetTermsConditionsUseCase {
  const GetTermsConditionsUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Either<Failure, List<TermsConditionEntity>>> call() {
    return _repository.getTermsConditions();
  }
}
