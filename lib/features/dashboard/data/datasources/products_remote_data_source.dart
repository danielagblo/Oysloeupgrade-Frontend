import 'package:dio/dio.dart';

import '../../../../core/constants/api.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/api_helper.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    String? search,
    String? ordering,
  });

  Future<ProductModel> getProductDetail(int id);

  Future<List<ReviewModel>> getProductReviews({
    required int productId,
  });

  Future<ReviewModel> createReview({
    required int productId,
    required int rating,
    String? comment,
  });

  Future<ReviewModel> updateReview({
    required int reviewId,
    required int rating,
    String? comment,
  });
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  ProductsRemoteDataSourceImpl({
    required Dio client,
    this.endpoint = AppStrings.productsURL,
  }) : _client = client;

  final Dio _client;
  final String endpoint;

  @override
  Future<List<ProductModel>> getProducts({
    String? search,
    String? ordering,
  }) async {
    try {
      final Response<dynamic> response = await _client.get<dynamic>(
        endpoint,
        queryParameters: _buildQuery(
          search: search,
          ordering: ordering,
        ),
      );

      if (response.data is List<dynamic>) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .whereType<Map<String, dynamic>>()
            .map(
              (Map<String, dynamic> item) =>
                  ProductModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
      }

      if (response.data == null) {
        return <ProductModel>[];
      }

      throw const ServerException('Invalid response structure');
    } on DioException catch (error) {
      throw ApiException(ApiHelper.getHumanReadableMessage(error));
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<ProductModel> getProductDetail(int id) async {
    try {
      final Response<dynamic> response = await _client.get<dynamic>(
        AppStrings.productDetailURL(id),
      );

      final dynamic data = response.data;
      if (data is Map<String, dynamic>) {
        return ProductModel.fromJson(Map<String, dynamic>.from(data));
      }

      throw const ServerException('Invalid response structure');
    } on DioException catch (error) {
      throw ApiException(ApiHelper.getHumanReadableMessage(error));
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<List<ReviewModel>> getProductReviews({
    required int productId,
  }) async {
    try {
      final Response<dynamic> response = await _client.get<dynamic>(
        AppStrings.reviewsURL,
        queryParameters: <String, dynamic>{'product': productId},
      );

      if (response.data is List<dynamic>) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .whereType<Map<String, dynamic>>()
            .map((Map<String, dynamic> item) =>
                ReviewModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      if (response.data == null) {
        return <ReviewModel>[];
      }

      throw const ServerException('Invalid response structure');
    } on DioException catch (error) {
      throw ApiException(ApiHelper.getHumanReadableMessage(error));
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<ReviewModel> createReview({
    required int productId,
    required int rating,
    String? comment,
  }) async {
    try {
      final Response<dynamic> response = await _client.post<dynamic>(
        AppStrings.reviewsURL,
        data: <String, dynamic>{
          'product': productId,
          'rating': rating,
          if (comment != null && comment.trim().isNotEmpty)
            'comment': comment.trim(),
        },
      );

      final dynamic data = response.data;
      if (data is Map<String, dynamic>) {
        return ReviewModel.fromJson(Map<String, dynamic>.from(data));
      }

      throw const ServerException('Invalid response structure');
    } on DioException catch (error) {
      throw ApiException(ApiHelper.getHumanReadableMessage(error));
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<ReviewModel> updateReview({
    required int reviewId,
    required int rating,
    String? comment,
  }) async {
    try {
      final Response<dynamic> response = await _client.put<dynamic>(
        AppStrings.reviewDetailURL(reviewId),
        data: <String, dynamic>{
          'rating': rating,
          if (comment != null && comment.trim().isNotEmpty)
            'comment': comment.trim(),
        },
      );

      final dynamic data = response.data;
      if (data is Map<String, dynamic>) {
        return ReviewModel.fromJson(Map<String, dynamic>.from(data));
      }

      throw const ServerException('Invalid response structure');
    } on DioException catch (error) {
      throw ApiException(ApiHelper.getHumanReadableMessage(error));
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Map<String, dynamic>? _buildQuery({
    String? search,
    String? ordering,
  }) {
    final Map<String, dynamic> query = <String, dynamic>{};
    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }
    if (ordering != null && ordering.isNotEmpty) {
      query['ordering'] = ordering;
    }
    return query.isEmpty ? null : query;
  }
}
