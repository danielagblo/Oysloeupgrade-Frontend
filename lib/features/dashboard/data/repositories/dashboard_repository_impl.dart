import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/subcategory_entity.dart';
import '../../domain/entities/alert_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/privacy_policy_entity.dart';
import '../../domain/entities/terms_condition_entity.dart';
import '../datasources/products_remote_data_source.dart';
import '../datasources/categories_remote_data_source.dart';
import '../datasources/categories_local_data_source.dart';
import '../datasources/subcategories_remote_data_source.dart';
import '../datasources/alerts_remote_data_source.dart';
import '../datasources/feedback_remote_data_source.dart';
import '../datasources/locations_remote_data_source.dart';
import '../datasources/privacy_policies_remote_data_source.dart';
import '../datasources/terms_conditions_remote_data_source.dart';
import '../models/category_model.dart';
import '../models/subcategory_model.dart';
import '../models/alert_model.dart';
import '../models/location_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  static const Duration _categoriesCacheTtl = Duration(hours: 12);
  DashboardRepositoryImpl({
    required ProductsRemoteDataSource remoteDataSource,
    required CategoriesRemoteDataSource categoriesRemoteDataSource,
    required CategoriesLocalDataSource categoriesLocalDataSource,
    required SubcategoriesRemoteDataSource subcategoriesRemoteDataSource,
    required LocationsRemoteDataSource locationsRemoteDataSource,
    required AlertsRemoteDataSource alertsRemoteDataSource,
    required FeedbackRemoteDataSource feedbackRemoteDataSource,
    required PrivacyPoliciesRemoteDataSource privacyPoliciesRemoteDataSource,
    required TermsConditionsRemoteDataSource termsConditionsRemoteDataSource,
    required Network network,
  })  : _remoteDataSource = remoteDataSource,
        _categoriesRemoteDataSource = categoriesRemoteDataSource,
        _categoriesLocalDataSource = categoriesLocalDataSource,
        _subcategoriesRemoteDataSource = subcategoriesRemoteDataSource,
        _locationsRemoteDataSource = locationsRemoteDataSource,
        _alertsRemoteDataSource = alertsRemoteDataSource,
        _feedbackRemoteDataSource = feedbackRemoteDataSource,
        _privacyPoliciesRemoteDataSource = privacyPoliciesRemoteDataSource,
        _termsConditionsRemoteDataSource = termsConditionsRemoteDataSource,
        _network = network;

  final ProductsRemoteDataSource _remoteDataSource;
  final CategoriesRemoteDataSource _categoriesRemoteDataSource;
  final CategoriesLocalDataSource _categoriesLocalDataSource;
  final SubcategoriesRemoteDataSource _subcategoriesRemoteDataSource;
  final LocationsRemoteDataSource _locationsRemoteDataSource;
  final AlertsRemoteDataSource _alertsRemoteDataSource;
  final FeedbackRemoteDataSource _feedbackRemoteDataSource;
  final PrivacyPoliciesRemoteDataSource _privacyPoliciesRemoteDataSource;
  final TermsConditionsRemoteDataSource _termsConditionsRemoteDataSource;
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

  @override
  Future<Either<Failure, ReviewEntity>> updateReview({
    required int reviewId,
    required int rating,
    String? comment,
  }) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final ReviewEntity review = await _remoteDataSource.updateReview(
        reviewId: reviewId,
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
        'Unexpected update review failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> submitFeedback({
    required int rating,
    required String message,
  }) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      await _feedbackRemoteDataSource.submitFeedback(
        rating: rating,
        message: message,
      );
      return right(null);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected submit feedback failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    bool forceRefresh = false,
  }) async {
    CachedCategories? cache;
    try {
      cache = await _categoriesLocalDataSource.readCategories();
    } on CacheException catch (error, stackTrace) {
      logError(
        'Unable to read cached categories',
        error: error,
        stackTrace: stackTrace,
      );
    }

    final bool cacheHasData = cache?.categories.isNotEmpty ?? false;
    final DateTime? fetchedAt = cache?.fetchedAt;
    final bool cacheIsFresh = cacheHasData &&
        fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < _categoriesCacheTtl;

    if (!forceRefresh && cacheIsFresh && cache != null) {
      return right(cache.categories.cast<CategoryEntity>());
    }

    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      if (cacheHasData && cache != null) {
        return right(cache.categories.cast<CategoryEntity>());
      }
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final List<CategoryModel> categories =
          await _categoriesRemoteDataSource.getCategories();
      try {
        await _categoriesLocalDataSource.cacheCategories(categories);
      } on CacheException catch (error, stackTrace) {
        logError(
          'Unable to cache categories',
          error: error,
          stackTrace: stackTrace,
        );
      }
      return right(categories.cast<CategoryEntity>());
    } on ApiException catch (error) {
      if (cacheHasData && cache != null) {
        return right(cache.categories.cast<CategoryEntity>());
      }
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      if (cacheHasData && cache != null) {
        return right(cache.categories.cast<CategoryEntity>());
      }
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected categories fetch failure',
        error: error,
        stackTrace: stackTrace,
      );
      if (cacheHasData && cache != null) {
        return right(cache.categories.cast<CategoryEntity>());
      }
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<SubcategoryEntity>>> getSubcategories({
    required int categoryId,
  }) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final List<SubcategoryModel> subcategories =
          await _subcategoriesRemoteDataSource.getSubcategories(
        categoryId: categoryId,
      );
      return right(subcategories.cast<SubcategoryEntity>());
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected subcategories fetch failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<LocationEntity>>> getLocations({
    String? ordering,
    String? region,
    String? search,
  }) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final List<LocationModel> locations =
          await _locationsRemoteDataSource.getLocations(
        ordering: ordering,
        region: region,
        search: search,
      );
      return right(locations.cast<LocationEntity>());
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected locations fetch failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<AlertEntity>>> getAlerts() async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final List<AlertModel> models = await _alertsRemoteDataSource.getAlerts();
      final List<AlertEntity> alerts = models
          .map<AlertEntity>((AlertModel model) => model)
          .toList()
        ..sort(
          (AlertEntity a, AlertEntity b) => b.createdAt.compareTo(a.createdAt),
        );
      return right(alerts);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected alerts fetch failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> markAlertRead({
    required AlertEntity alert,
  }) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final AlertModel payload =
          AlertModel.fromEntity(alert.copyWith(isRead: true));
      await _alertsRemoteDataSource.markAlertRead(payload);
      return right(null);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected mark alert read failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAlert({
    required int alertId,
  }) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      await _alertsRemoteDataSource.deleteAlert(alertId);
      return right(null);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected delete alert failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<PrivacyPolicyEntity>>> getPrivacyPolicies() async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final List<PrivacyPolicyEntity> policies =
          (await _privacyPoliciesRemoteDataSource.getPrivacyPolicies())
              .cast<PrivacyPolicyEntity>();
      return right(policies);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected privacy policies fetch failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<TermsConditionEntity>>> getTermsConditions() async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final List<TermsConditionEntity> terms =
          (await _termsConditionsRemoteDataSource.getTermsConditions())
              .cast<TermsConditionEntity>();
      return right(terms);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError(
        'Unexpected terms fetch failure',
        error: error,
        stackTrace: stackTrace,
      );
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }
}
