import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/location_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetLocationsUseCase {
  const GetLocationsUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Either<Failure, List<LocationEntity>>> call({
    String? ordering,
    String? region,
    String? search,
  }) {
    return _repository.getLocations(
      ordering: ordering,
      region: region,
      search: search,
    );
  }
}
