import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/product_entity.dart';
import '../entities/review_entity.dart';
import '../entities/category_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? search,
    String? ordering,
  });

  Future<Either<Failure, ProductEntity>> getProductDetail({
    required int id,
  });

  Future<Either<Failure, List<ReviewEntity>>> getProductReviews({
    required int productId,
  });

  Future<Either<Failure, ReviewEntity>> createReview({
    required int productId,
    required int rating,
    String? comment,
  });

  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
