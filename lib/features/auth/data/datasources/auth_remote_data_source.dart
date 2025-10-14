import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/usecase/login_params.dart';
import '../../../../core/usecase/register_params.dart';
import '../../../../core/utils/api_helper.dart';
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
      final Map<String, dynamic> data = ApiHelper.extractPayload(response);
      return AuthSessionModel.fromJson(data);
    } on DioException catch (error) {
      throw ApiException(ApiHelper.getHumanReadableMessage(error));
    } on ServerException {
      rethrow;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

}
