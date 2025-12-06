import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/privacy_policy_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetPrivacyPoliciesUseCase {
  const GetPrivacyPoliciesUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Either<Failure, List<PrivacyPolicyEntity>>> call() {
    return _repository.getPrivacyPolicies();
  }
}
