import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/entities/review_entity.dart';
import '../datasources/products_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    required ProductsRemoteDataSource remoteDataSource,
    required Network network,
  })  : _remoteDataSource = remoteDataSource,
        _network = network;

  final ProductsRemoteDataSource _remoteDataSource;
  final Network _network;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? search,
    String? ordering,
  }) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final List<ProductEntity> products = (await _remoteDataSource.getProducts(
        search: search,
        ordering: ordering,
      ))
          .cast<ProductEntity>();
      return right(products);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected products fetch failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductDetail({
    required int id,
  }) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final ProductEntity product =
          await _remoteDataSource.getProductDetail(id);
      return right(product);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected product detail fetch failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getProductReviews({
    required int productId,
  }) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final List<ReviewEntity> reviews =
          (await _remoteDataSource.getProductReviews(productId: productId))
              .cast<ReviewEntity>();
      return right(reviews);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected product reviews fetch failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> createReview({
    required int productId,
    required int rating,
    String? comment,
  }) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final ReviewEntity review = await _remoteDataSource.createReview(
        productId: productId,
        rating: rating,
        comment: comment,
      );
      return right(review);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected create review failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }
}
