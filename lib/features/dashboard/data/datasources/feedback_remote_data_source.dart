import 'package:dio/dio.dart';

import '../../../../core/constants/api.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/api_helper.dart';

abstract class FeedbackRemoteDataSource {
  Future<void> submitFeedback({
    required int rating,
    required String message,
  });
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  FeedbackRemoteDataSourceImpl({
    required Dio client,
    this.endpoint = AppStrings.feedbackURL,
  }) : _client = client;

  final Dio _client;
  final String endpoint;

  @override
  Future<void> submitFeedback({
    required int rating,
    required String message,
  }) async {
    try {
      await _client.post<dynamic>(
        endpoint,
        data: <String, dynamic>{
          'rating': rating,
          'message': message.trim(),
        },
      );
    } on DioException catch (error) {
      throw ApiException(ApiHelper.getHumanReadableMessage(error));
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
