import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/usecase/login_params.dart';
import '../../../../core/usecase/register_params.dart';
import '../models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> register(RegisterParams params);
  Future<AuthSessionModel> login(LoginParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required Dio client,
    this.registerEndpoint = 'register/',
    this.loginEndpoint = 'login/',
  }) : _client = client;

  final Dio _client;
  final String registerEndpoint;
  final String loginEndpoint;

  @override
  Future<AuthSessionModel> register(RegisterParams params) async {
    return _post(registerEndpoint, params.toJson());
  }

  @override
  Future<AuthSessionModel> login(LoginParams params) async {
    return _post(loginEndpoint, params.toJson());
  }

  Future<AuthSessionModel> _post(
    String endpoint,
    Map<String, dynamic> payload,
  ) async {
    try {
      final Response<dynamic> response =
          await _client.post<dynamic>(endpoint, data: payload);
      final Map<String, dynamic> data = _extractPayload(response);
      return AuthSessionModel.fromJson(data);
    } on DioException catch (error) {
      throw ApiException(_humanReadableMessage(error));
    } on ServerException {
      rethrow;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Map<String, dynamic> _extractPayload(Response<dynamic> response) {
    if (response.data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(response.data as Map<String, dynamic>);
    }
    if (response.data == null) {
      throw const ServerException('Empty response');
    }
    throw const ServerException('Invalid response structure');
  }

  String _humanReadableMessage(DioException error) {
    final Response<dynamic>? response = error.response;
    if (response?.data is Map<String, dynamic>) {
      final Map<String, dynamic> map =
          Map<String, dynamic>.from(response!.data as Map<String, dynamic>);
      const List<String> keys = <String>['message', 'detail', 'error', 'error_message'];
      for (final String key in keys) {
        final dynamic value = map[key];
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }
    if (error.message != null && error.message!.isNotEmpty) {
      return error.message!;
    }
    return 'Unable to complete request';
  }
}
