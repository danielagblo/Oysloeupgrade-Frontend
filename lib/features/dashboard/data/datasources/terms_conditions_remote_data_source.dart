import 'package:dio/dio.dart';

import '../../../../core/constants/api.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/api_helper.dart';
import '../models/terms_condition_model.dart';

abstract class TermsConditionsRemoteDataSource {
  Future<List<TermsConditionModel>> getTermsConditions();
}

class TermsConditionsRemoteDataSourceImpl
    implements TermsConditionsRemoteDataSource {
  TermsConditionsRemoteDataSourceImpl({
    required Dio client,
    this.endpoint = AppStrings.termsConditionsURL,
  }) : _client = client;

  final Dio _client;
  final String endpoint;

  @override
  Future<List<TermsConditionModel>> getTermsConditions() async {
    try {
      final Response<dynamic> response = await _client.get<dynamic>(endpoint);

      if (response.data is List<dynamic>) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .whereType<Map<String, dynamic>>()
            .map(
              (Map<String, dynamic> raw) =>
                  TermsConditionModel.fromJson(Map<String, dynamic>.from(raw)),
            )
            .toList();
      }

      if (response.data == null) {
        return <TermsConditionModel>[];
      }

      throw const ServerException('Invalid response structure');
    } on DioException catch (error) {
      throw ApiException(ApiHelper.getHumanReadableMessage(error));
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
