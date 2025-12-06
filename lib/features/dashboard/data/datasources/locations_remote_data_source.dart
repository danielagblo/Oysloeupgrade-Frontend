import 'package:dio/dio.dart';

import '../../../../core/constants/api.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/api_helper.dart';
import '../models/location_model.dart';

abstract class LocationsRemoteDataSource {
  Future<List<LocationModel>> getLocations({
    String? ordering,
    String? region,
    String? search,
  });
}

class LocationsRemoteDataSourceImpl implements LocationsRemoteDataSource {
  LocationsRemoteDataSourceImpl({
    required Dio client,
    this.endpoint = AppStrings.locationsURL,
  }) : _client = client;

  final Dio _client;
  final String endpoint;

  @override
  Future<List<LocationModel>> getLocations({
    String? ordering,
    String? region,
    String? search,
  }) async {
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      if (ordering != null && ordering.trim().isNotEmpty) 'ordering': ordering,
      if (region != null && region.trim().isNotEmpty) 'region': region,
      if (search != null && search.trim().isNotEmpty) 'search': search,
    };

    try {
      final Response<dynamic> response = await _client.get<dynamic>(
        endpoint,
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );
      final dynamic data = response.data;

      if (data is List<dynamic>) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(
              (Map<String, dynamic> item) =>
                  LocationModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
      }

      if (data == null) {
        return const <LocationModel>[];
      }

      throw const ServerException('Invalid response structure');
    } on DioException catch (error) {
      throw ApiException(ApiHelper.getHumanReadableMessage(error));
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
