import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/usecase/otp_params.dart';
import '../../../../core/utils/api_helper.dart';
import '../models/otp_model.dart';

abstract class OtpRemoteDataSource {
  Future<OtpResponseModel> sendOtp(SendOtpParams params);
  Future<OtpResponseModel> verifyOtp(VerifyOtpParams params);
}

class OtpRemoteDataSourceImpl implements OtpRemoteDataSource {
  OtpRemoteDataSourceImpl({
    required Dio client,
    this.endpoint = 'verifyotp/',
  }) : _client = client;

  final Dio _client;
  final String endpoint;

  @override
  Future<OtpResponseModel> sendOtp(SendOtpParams params) async {
    try {
      final Response<dynamic> response = await _client.get<dynamic>(
        endpoint,
        queryParameters: params.toQueryParams(),
      );
      final Map<String, dynamic> data = ApiHelper.extractPayload(response);
      return OtpResponseModel.fromJson(data);
    } on DioException catch (error) {
      throw ApiException(ApiHelper.getDioExceptionMessage(error));
    } on ServerException {
      rethrow;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<OtpResponseModel> verifyOtp(VerifyOtpParams params) async {
    try {
      final Response<dynamic> response =
          await _client.post<dynamic>(endpoint, data: params.toJson());
      final Map<String, dynamic> data = ApiHelper.extractPayload(response);
      return OtpResponseModel.fromJson(data);
    } on DioException catch (error) {
      throw ApiException(ApiHelper.getDioExceptionMessage(error));
    } on ServerException {
      rethrow;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

}