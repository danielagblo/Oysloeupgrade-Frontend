import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/subcategory_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetSubcategoriesUseCase {
  const GetSubcategoriesUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Either<Failure, List<SubcategoryEntity>>> call({
    required int categoryId,
  }) {
    return _repository.getSubcategories(categoryId: categoryId);
  }
}
