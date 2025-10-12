part of 'dependency_injection.dart';

Future<void> _initCore() async {
	sl
				..registerLazySingleton<InternetConnectionChecker>(
					() => InternetConnectionChecker.instance,
			)
		..registerLazySingleton<Network>(
			() => NetworkImpl(sl()),
		)
		..registerLazySingleton<Dio>(() {
			final dio = Dio(
				BaseOptions(
					baseUrl: AppStrings.baseUrl,
					connectTimeout: const Duration(seconds: 20),
					receiveTimeout: const Duration(seconds: 20),
					contentType: 'application/json',
				),
			);

			dio.interceptors.add(
				PrettyDioLogger(
					requestHeader: true,
					requestBody: true,
					responseBody: true,
					responseHeader: false,
				),
			);

			return dio;
		});
}

Future<void> _initAuth() async {
	sl
		..registerLazySingleton<AuthLocalDataSource>(
			() => AuthLocalDataSourceImpl(box: sl(instanceName: 'auth_box')),
		)
			..registerLazySingleton<AuthRemoteDataSource>(
				() => AuthRemoteDataSourceImpl(client: sl()),
		)
		..registerLazySingleton<AuthRepository>(
			() => AuthRepositoryImpl(
					remoteDataSource: sl(),
				localDataSource: sl(),
				network: sl(),
				client: sl(),
			),
		)
		..registerLazySingleton<RegisterUseCase>(
			() => RegisterUseCase(sl()),
		)
		..registerLazySingleton<LoginUseCase>(
			() => LoginUseCase(sl()),
		)
		..registerLazySingleton<GetCachedSessionUseCase>(
			() => GetCachedSessionUseCase(sl()),
		)
		..registerLazySingleton<LogoutUseCase>(
			() => LogoutUseCase(sl()),
		)
		..registerFactory<RegisterCubit>(
			() => RegisterCubit(sl()),
		)
		..registerFactory<LoginCubit>(
			() => LoginCubit(sl(), sl()),
		);

	await sl<GetCachedSessionUseCase>()(const NoParams());
}