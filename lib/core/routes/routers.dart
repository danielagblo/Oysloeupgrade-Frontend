part of "routes.dart";

final List<RouteBase> routes = <RouteBase>[
  GoRoute(
    name: AppRouteNames.splash,
    path: AppRoutePaths.splash,
    pageBuilder: defaultPageBuilder(const SplashScreen()),
  ),
  GoRoute(
    name: AppRouteNames.onboarding,
    path: AppRoutePaths.onboarding,
    pageBuilder: defaultPageBuilder(const OnboardingFlow()),
  ),
  GoRoute(
    name: AppRouteNames.signup,
    path: AppRoutePaths.signup,
    pageBuilder: (context, state) {
      return buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: BlocProvider(
          create: (_) => sl<RegisterCubit>(),
          child: const SignupScreen(),
        ),
      );
    },
  ),
  GoRoute(
    name: AppRouteNames.login,
    path: AppRoutePaths.login,
    pageBuilder: (context, state) {
      return buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: BlocProvider(
          create: (_) => sl<LoginCubit>(),
          child: const LoginScreen(),
        ),
      );
    },
  ),
  GoRoute(
    name: AppRouteNames.emailPasswordReset,
    path: AppRoutePaths.emailPasswordReset,
    pageBuilder: defaultPageBuilder(const EmailPasswordResetScreen()),
  ),
  GoRoute(
    name: AppRouteNames.otpLogin,
    path: AppRoutePaths.otpLogin,
    pageBuilder: (context, state) {
      return buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: BlocProvider(
          create: (_) => sl<OtpCubit>(),
          child: const OtpLoginScreen(),
        ),
      );
    },
  ),
  GoRoute(
    name: AppRouteNames.referralCode,
    path: AppRoutePaths.referralCode,
    pageBuilder: defaultPageBuilder(const ReferralCodeScreen()),
  ),
  GoRoute(
    name: AppRouteNames.otpVerification,
    path: AppRoutePaths.otpVerification,
    pageBuilder: (context, state) {
      final phone = state.extra as String? ?? '';
      return buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: BlocProvider(
          create: (_) => sl<OtpCubit>(),
          child: OtpVerificationScreen(phone: phone),
        ),
      );
    },
  ),
  ShellRoute(
    builder: (context, state, child) {
      int currentIndex = 0;
      final String location = state.uri.toString();

      if (location.startsWith(AppRoutePaths.dashboardAlerts)) {
        currentIndex = 1;
      } else if (location.startsWith(AppRoutePaths.dashboardPostAd)) {
        currentIndex = 2;
      } else if (location.startsWith(AppRoutePaths.dashboardInbox)) {
        currentIndex = 3;
      } else if (location.startsWith('/dashboard/profile')) {
        currentIndex = 4;
      }

      return NavigationShell(
        currentIndex: currentIndex,
        child: child,
      );
    },
    routes: [
      GoRoute(
        name: AppRouteNames.dashboardHome,
        path: AppRoutePaths.dashboardHome,
        pageBuilder: defaultPageBuilder(const AnimatedHomeScreen()),
        routes: [
          GoRoute(
            name: AppRouteNames.dashboardHomeAdDetail,
            path: AppRoutePaths.dashboardHomeAdDetail,
            pageBuilder: (context, state) {
              final adId = state.pathParameters['adId']!;
              final extra = state.extra as Map<String, dynamic>?;
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: AdDetailScreen(
                  adId: adId,
                  adType: extra?['adType'] as AdDealType?,
                  imageUrl: extra?['imageUrl'] as String?,
                  title: extra?['title'] as String?,
                  location: extra?['location'] as String?,
                  prices: extra?['prices'] as List<String>?,
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRouteNames.dashboardAlerts,
        path: AppRoutePaths.dashboardAlerts,
        pageBuilder: defaultPageBuilder(const AlertsScreen()),
        routes: [
          GoRoute(
            name: AppRouteNames.dashboardAlertsAdDetail,
            path: AppRoutePaths.dashboardAlertsAdDetail,
            pageBuilder: (context, state) {
              final adId = state.pathParameters['adId']!;
              final extra = state.extra as Map<String, dynamic>?;
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: AdDetailScreen(
                  adId: adId,
                  adType: extra?['adType'] as AdDealType?,
                  imageUrl: extra?['imageUrl'] as String?,
                  title: extra?['title'] as String?,
                  location: extra?['location'] as String?,
                  prices: extra?['prices'] as List<String>?,
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRouteNames.dashboardPostAd,
        path: AppRoutePaths.dashboardPostAd,
        pageBuilder: defaultPageBuilder(const PostAdUploadImagesScreen()),
        routes: [
          GoRoute(
            name: AppRouteNames.dashboardPostAdForm,
            path: AppRoutePaths.dashboardPostAdForm,
            pageBuilder: (context, state) {
              final selectedImages = state.extra as List<String>?;
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: PostAdFormScreen(selectedImages: selectedImages),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRouteNames.dashboardInbox,
        path: AppRoutePaths.dashboardInbox,
        pageBuilder: defaultPageBuilder(const InboxScreen()),
        routes: [
          GoRoute(
            name: AppRouteNames.dashboardChat,
            path: AppRoutePaths.dashboardChat,
            pageBuilder: (context, state) {
              final chatId = state.pathParameters['chatId']!;
              final extra = state.extra as Map<String, dynamic>?;
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: ChatScreen(
                  chatId: chatId,
                  otherUserName:
                      extra?['otherUserName'] as String? ?? 'Unknown',
                  otherUserAvatar: extra?['otherUserAvatar'] as String? ??
                      'assets/images/man.jpg',
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRouteNames.dashboardEditProfile,
        path: AppRoutePaths.dashboardEditProfile,
        pageBuilder: defaultPageBuilder(const EditProfileScreen()),
      ),
      GoRoute(
        name: AppRouteNames.dashboardAds,
        path: AppRoutePaths.dashboardAds,
        pageBuilder: defaultPageBuilder(const AdScreen()),
      ),
      GoRoute(
        name: AppRouteNames.dashboardFavorites,
        path: AppRoutePaths.dashboardFavorites,
        pageBuilder: defaultPageBuilder(const FavoriteScreen()),
      ),
      GoRoute(
        name: AppRouteNames.dashboardSubscription,
        path: AppRoutePaths.dashboardSubscription,
        pageBuilder: defaultPageBuilder(const SubscriptionScreen()),
      ),
      GoRoute(
        name: AppRouteNames.dashboardReferEarn,
        path: AppRoutePaths.dashboardReferEarn,
        pageBuilder: defaultPageBuilder(const ReferAndEarnScreen()),
      ),
      GoRoute(
        name: AppRouteNames.dashboardFeedback,
        path: AppRoutePaths.dashboardFeedback,
        pageBuilder: defaultPageBuilder(const FeedbackScreen()),
      ),
      GoRoute(
        name: AppRouteNames.dashboardReviews,
        path: AppRoutePaths.dashboardReviews,
        pageBuilder: defaultPageBuilder(const ReviewsScreen()),
      ),
      GoRoute(
        name: AppRouteNames.dashboardServices,
        path: AppRoutePaths.dashboardServices,
        pageBuilder: defaultPageBuilder(const ServicesScreen()),
      ),
      GoRoute(
        name: AppRouteNames.dashboardServicesAdditional,
        path: AppRoutePaths.dashboardServicesAdditional,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: ServicesAdditionalScreen(
              initial: state.extra as dynamic,
            ),
          );
        },
      ),
      GoRoute(
        name: AppRouteNames.dashboardServicesReview,
        path: AppRoutePaths.dashboardServicesReview,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: ServicesReviewScreen(
              initial: state.extra as dynamic,
            ),
          );
        },
      ),
      GoRoute(
        name: AppRouteNames.dashboardReport,
        path: AppRoutePaths.dashboardReport,
        pageBuilder: defaultPageBuilder(const ReportScreen()),
      ),
      GoRoute(
        name: AppRouteNames.dashboardPrivacyPolicy,
        path: AppRoutePaths.dashboardPrivacyPolicy,
        pageBuilder: defaultPageBuilder(const PrivacyPolicyScreen()),
      ),
      GoRoute(
        name: AppRouteNames.dashboardTermsConditions,
        path: AppRoutePaths.dashboardTermsConditions,
        pageBuilder: defaultPageBuilder(const TermsConditionsScreen()),
      ),
      GoRoute(
        name: AppRouteNames.dashboardAccount,
        path: AppRoutePaths.dashboardAccount,
        pageBuilder: defaultPageBuilder(const AccountScreen()),
      ),
    ],
  ),
  GoRoute(
    name: AppRouteNames.legacyHomeRedirect,
    path: AppRoutePaths.legacyHomeRedirect,
    redirect: (_, __) => AppRoutePaths.dashboardHome,
  ),
];

final GoRouter appRouter = GoRouter(
  routes: routes,
  initialLocation: AppRoutePaths.splash,
);
