import 'package:dio/dio.dart';

import '../../../../core/constants/api.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/api_helper.dart';
import '../models/privacy_policy_model.dart';

abstract class PrivacyPoliciesRemoteDataSource {
  Future<List<PrivacyPolicyModel>> getPrivacyPolicies();
}

class PrivacyPoliciesRemoteDataSourceImpl
    implements PrivacyPoliciesRemoteDataSource {
  PrivacyPoliciesRemoteDataSourceImpl({
    required Dio client,
    this.endpoint = AppStrings.privacyPoliciesURL,
  }) : _client = client;

  final Dio _client;
  final String endpoint;

  @override
  Future<List<PrivacyPolicyModel>> getPrivacyPolicies() async {
    try {
      final Response<dynamic> response = await _client.get<dynamic>(endpoint);

      if (response.data is List<dynamic>) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .whereType<Map<String, dynamic>>()
            .map(
              (Map<String, dynamic> raw) =>
                  PrivacyPolicyModel.fromJson(Map<String, dynamic>.from(raw)),
            )
            .toList();
      }

      if (response.data == null) {
        return <PrivacyPolicyModel>[];
      }

      throw const ServerException('Invalid response structure');
    } on DioException catch (error) {
      throw ApiException(ApiHelper.getHumanReadableMessage(error));
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
