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
    ..registerLazySingleton<OtpRemoteDataSource>(
      () => OtpRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        otpRemoteDataSource: sl(),
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
    ..registerLazySingleton<SendOtpUseCase>(
      () => SendOtpUseCase(sl()),
    )
    ..registerLazySingleton<VerifyOtpUseCase>(
      () => VerifyOtpUseCase(sl()),
    )
    ..registerLazySingleton<VerifyResetOtpUseCase>(
      () => VerifyResetOtpUseCase(sl()),
    )
    ..registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(sl()),
    )
    ..registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(sl()),
    )
    ..registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(sl()),
    )
    ..registerFactory<RegisterCubit>(
      () => RegisterCubit(sl()),
    )
    ..registerFactory<LoginCubit>(
      () => LoginCubit(sl(), sl()),
    )
    ..registerFactory<OtpCubit>(
      () => OtpCubit(sl(), sl()),
    )
    ..registerFactory<PasswordResetCubit>(
      () => PasswordResetCubit(sl(), sl(), sl()),
    );

  await sl<GetCachedSessionUseCase>()(const NoParams());
}

Future<void> _initDashboard() async {
  sl
    ..registerLazySingleton<ProductsRemoteDataSource>(
      () => ProductsRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<CategoriesRemoteDataSource>(
      () => CategoriesRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<CategoriesLocalDataSource>(
      () => CategoriesLocalDataSourceImpl(
        box: sl(instanceName: 'categories_box'),
      ),
    )
    ..registerLazySingleton<SubcategoriesRemoteDataSource>(
      () => SubcategoriesRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<LocationsRemoteDataSource>(
      () => LocationsRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<AlertsRemoteDataSource>(
      () => AlertsRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<FeedbackRemoteDataSource>(
      () => FeedbackRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<PrivacyPoliciesRemoteDataSource>(
      () => PrivacyPoliciesRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<TermsConditionsRemoteDataSource>(
      () => TermsConditionsRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        remoteDataSource: sl(),
        categoriesRemoteDataSource: sl(),
        categoriesLocalDataSource: sl(),
        subcategoriesRemoteDataSource: sl(),
        locationsRemoteDataSource: sl(),
        alertsRemoteDataSource: sl(),
        feedbackRemoteDataSource: sl(),
        privacyPoliciesRemoteDataSource: sl(),
        termsConditionsRemoteDataSource: sl(),
        network: sl(),
      ),
    )
    ..registerLazySingleton<GetLocationsUseCase>(
      () => GetLocationsUseCase(sl()),
    )
    ..registerLazySingleton<GetProductsUseCase>(
      () => GetProductsUseCase(sl()),
    )
    ..registerLazySingleton<GetProductReviewsUseCase>(
      () => GetProductReviewsUseCase(sl()),
    )
    ..registerLazySingleton<GetProductDetailUseCase>(
      () => GetProductDetailUseCase(sl()),
    )
    ..registerLazySingleton<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(sl()),
    )
    ..registerLazySingleton<GetSubcategoriesUseCase>(
      () => GetSubcategoriesUseCase(sl()),
    )
    ..registerLazySingleton<GetAlertsUseCase>(
      () => GetAlertsUseCase(sl()),
    )
    ..registerLazySingleton<MarkAlertReadUseCase>(
      () => MarkAlertReadUseCase(sl()),
    )
    ..registerLazySingleton<DeleteAlertUseCase>(
      () => DeleteAlertUseCase(sl()),
    )
    ..registerLazySingleton<CreateReviewUseCase>(
      () => CreateReviewUseCase(sl()),
    )
    ..registerLazySingleton<UpdateReviewUseCase>(
      () => UpdateReviewUseCase(sl()),
    )
    ..registerLazySingleton<SubmitFeedbackUseCase>(
      () => SubmitFeedbackUseCase(sl()),
    )
    ..registerLazySingleton<GetPrivacyPoliciesUseCase>(
      () => GetPrivacyPoliciesUseCase(sl()),
    )
    ..registerLazySingleton<GetTermsConditionsUseCase>(
      () => GetTermsConditionsUseCase(sl()),
    )
    ..registerFactory<ProductsCubit>(
      () => ProductsCubit(sl()),
    )
    ..registerFactory<CategoriesCubit>(
      () => CategoriesCubit(sl()),
    )
    ..registerFactory<SubcategoriesCubit>(
      () => SubcategoriesCubit(sl()),
    )
    ..registerFactory<LocationsCubit>(
      () => LocationsCubit(sl()),
    )
    ..registerSingleton<AlertsCubit>(
      AlertsCubit(sl(), sl(), sl()),
    )
    ..registerFactory<ProfileCubit>(
      () => ProfileCubit(
        sl<GetCachedSessionUseCase>(),
        sl<GetProfileUseCase>(),
        sl<UpdateProfileUseCase>(),
      ),
    )
    ..registerFactory<PrivacyPoliciesCubit>(
      () => PrivacyPoliciesCubit(sl()),
    )
    ..registerFactory<TermsConditionsCubit>(
      () => TermsConditionsCubit(sl()),
    );
}
