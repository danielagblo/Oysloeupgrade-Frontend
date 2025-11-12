import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:oysloe_mobile/core/constants/api.dart';
import 'package:oysloe_mobile/core/network/network_info.dart';
import 'package:oysloe_mobile/core/usecase/usecase.dart';
import 'package:oysloe_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:oysloe_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:oysloe_mobile/features/auth/data/datasources/otp_remote_data_source.dart';
import 'package:oysloe_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:oysloe_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:oysloe_mobile/features/auth/domain/usecases/get_cached_session_usecase.dart';
import 'package:oysloe_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:oysloe_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:oysloe_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:oysloe_mobile/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:oysloe_mobile/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:oysloe_mobile/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:oysloe_mobile/features/auth/domain/usecases/verify_reset_otp_usecase.dart';
import 'package:oysloe_mobile/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:oysloe_mobile/features/auth/presentation/bloc/otp/otp_cubit.dart';
import 'package:oysloe_mobile/features/auth/presentation/bloc/password_reset/password_reset_cubit.dart';
import 'package:oysloe_mobile/features/auth/presentation/bloc/register/register_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/data/datasources/products_remote_data_source.dart';
import 'package:oysloe_mobile/features/dashboard/data/datasources/categories_remote_data_source.dart';
import 'package:oysloe_mobile/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:oysloe_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:oysloe_mobile/features/dashboard/domain/usecases/get_products_usecase.dart';
import 'package:oysloe_mobile/features/dashboard/domain/usecases/get_product_reviews_usecase.dart';
import 'package:oysloe_mobile/features/dashboard/domain/usecases/get_product_detail_usecase.dart';
import 'package:oysloe_mobile/features/dashboard/domain/usecases/create_review_usecase.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/products/products_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/domain/usecases/get_categories_usecase.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/categories/categories_cubit.dart';

part 'di.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await Hive.initFlutter();
  final Box<dynamic> authBox = await Hive.openBox<dynamic>('auth_box');
  if (!sl.isRegistered<Box<dynamic>>(instanceName: 'auth_box')) {
    sl.registerSingleton<Box<dynamic>>(authBox, instanceName: 'auth_box');
  }
  await _initCore();
  await _initAuth();
  await _initDashboard();
}
