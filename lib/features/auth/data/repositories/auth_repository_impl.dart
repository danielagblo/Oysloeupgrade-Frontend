import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecase/login_params.dart';
import '../../../../core/usecase/otp_params.dart';
import '../../../../core/usecase/register_params.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/otp_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/otp_remote_data_source.dart';
import '../models/auth_session_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required OtpRemoteDataSource otpRemoteDataSource,
    required Network network,
    required Dio client,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _otpRemoteDataSource = otpRemoteDataSource,
        _network = network,
        _client = client;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final OtpRemoteDataSource _otpRemoteDataSource;
  final Network _network;
  final Dio _client;

  @override
  Future<Either<Failure, AuthSessionEntity>> register(
    RegisterParams params,
  ) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
    final AuthSessionModel session =
      await _remoteDataSource.register(params);
      return await _persistSession(session);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError('Unexpected register failure',
          error: error, stackTrace: stackTrace);
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AuthSessionEntity>> login(LoginParams params) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
    final AuthSessionModel session =
      await _remoteDataSource.login(params);
      return await _persistSession(session);
    } on ApiException catch (error) {
      return left(LoginFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError('Unexpected login failure',
          error: error, stackTrace: stackTrace);
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearSession();
      _setAuthHeader(null);
      return right(null);
    } on CacheException catch (error) {
      return left(CacheFailure(error.message));
    } catch (error, stackTrace) {
      logError('Unexpected logout failure',
          error: error, stackTrace: stackTrace);
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<AuthSessionEntity?> cachedSession() async {
    try {
      final AuthSessionModel? session = await _localDataSource.readSession();
      if (session != null) {
        _setAuthHeader(session.token);
      }
      return session;
    } on CacheException catch (error) {
      logError('Unable to restore cached session', error: error);
      return null;
    }
  }

  Future<Either<Failure, AuthSessionEntity>> _persistSession(
    AuthSessionModel session,
  ) async {
    try {
      await _localDataSource.cacheSession(session);
      _setAuthHeader(session.token);
      return right(session);
    } on CacheException catch (error) {
      return left(CacheFailure(error.message));
    } catch (error, stackTrace) {
      logError('Unexpected cache failure',
          error: error, stackTrace: stackTrace);
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, OtpResponseEntity>> sendOtp(SendOtpParams params) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final result = await _otpRemoteDataSource.sendOtp(params);
      return right(result);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError('Unexpected sendOtp failure',
          error: error, stackTrace: stackTrace);
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, OtpResponseEntity>> verifyOtp(VerifyOtpParams params) async {
    final bool isConnected = await _network.isConnected;
    if (!isConnected) {
      return left(const NetworkFailure('No internet connection'));
    }

    try {
      final result = await _otpRemoteDataSource.verifyOtp(params);
      return right(result);
    } on ApiException catch (error) {
      return left(APIFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } catch (error, stackTrace) {
      logError('Unexpected verifyOtp failure',
          error: error, stackTrace: stackTrace);
      return left(const ServerFailure('Unexpected error occurred'));
    }
  }

  void _setAuthHeader(String? token) {
    if (token == null || token.isEmpty) {
      _client.options.headers.remove('Authorization');
    } else {
      _client.options.headers['Authorization'] = 'Token $token';
    }
  }
}
