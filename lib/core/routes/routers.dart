import 'package:go_router/go_router.dart';
import 'package:oysloe_mobile/core/navigation/navigation_shell.dart';
import 'package:oysloe_mobile/features/auth/presentation/pages/email_password_reset.dart';
import 'package:oysloe_mobile/features/auth/presentation/pages/login_screen.dart';
import 'package:oysloe_mobile/features/auth/presentation/pages/otp_login_screen.dart';
import 'package:oysloe_mobile/features/auth/presentation/pages/otp_verification_screen.dart';
import 'package:oysloe_mobile/features/auth/presentation/pages/referral_code_screen.dart';
import 'package:oysloe_mobile/features/auth/presentation/pages/signup_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/home_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/alerts_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/ad_detail_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/inbox_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/chat_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/edit_profile_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/ad_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/favorite_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/feedback_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/privacy_policy_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/subscription_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/terms_conditions_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/account_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/post_ad_upload_images_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/post_ad_form_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/ad_card.dart';
import 'package:oysloe_mobile/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:oysloe_mobile/features/onboarding/presentation/pages/onboarding_flow.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingFlow(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/email-password-reset',
      name: 'email-password-reset',
      builder: (context, state) => const EmailPasswordResetScreen(),
    ),
    GoRoute(
      path: '/otp-login',
      name: 'otp-login',
      builder: (context, state) => const OtpLoginScreen(),
    ),
    GoRoute(
      path: '/referral-code',
      name: 'referral-code',
      builder: (context, state) => const ReferralCodeScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      name: 'otp-verification',
      builder: (context, state) => const OtpVerificationScreen(),
    ),

    // Dashboard Shell Route
    ShellRoute(
      builder: (context, state, child) {
        int currentIndex = 0;
        final String location = state.uri.toString();

        if (location.startsWith('/dashboard/alerts')) {
          currentIndex = 1;
        } else if (location.startsWith('/dashboard/post-ad')) {
          currentIndex = 2;
        } else if (location.startsWith('/dashboard/inbox')) {
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
        // Home Tab
        GoRoute(
          path: '/dashboard/home',
          name: 'home',
          builder: (context, state) => const AnimatedHomeScreen(),
          routes: [
            GoRoute(
              path: 'ad-detail/:adId',
              name: 'home-ad-detail',
              builder: (context, state) {
                final adId = state.pathParameters['adId']!;
                final extra = state.extra as Map<String, dynamic>?;
                return AdDetailScreen(
                  adId: adId,
                  adType: extra?['adType'] as AdDealType?,
                  imageUrl: extra?['imageUrl'] as String?,
                  title: extra?['title'] as String?,
                  location: extra?['location'] as String?,
                  prices: extra?['prices'] as List<String>?,
                );
              },
            ),
          ],
        ),

        // Alerts Tab
        GoRoute(
          path: '/dashboard/alerts',
          name: 'alerts',
          builder: (context, state) => const AlertsScreen(),
          routes: [
            GoRoute(
              path: 'ad-detail/:adId',
              name: 'alerts-ad-detail',
              builder: (context, state) {
                final adId = state.pathParameters['adId']!;
                final extra = state.extra as Map<String, dynamic>?;
                return AdDetailScreen(
                  adId: adId,
                  adType: extra?['adType'] as AdDealType?,
                  imageUrl: extra?['imageUrl'] as String?,
                  title: extra?['title'] as String?,
                  location: extra?['location'] as String?,
                  prices: extra?['prices'] as List<String>?,
                );
              },
            ),
          ],
        ),

        // Post Ad Tab
        GoRoute(
          path: '/dashboard/post-ad',
          name: 'post-ad',
          builder: (context, state) => const PostAdUploadImagesScreen(),
          routes: [
            GoRoute(
              path: 'form',
              name: 'post-ad-form',
              builder: (context, state) {
                final selectedImages = state.extra as List<String>?;
                return PostAdFormScreen(selectedImages: selectedImages);
              },
            ),
          ],
        ),

        // Inbox Tab
        GoRoute(
          path: '/dashboard/inbox',
          name: 'inbox',
          builder: (context, state) => const InboxScreen(),
          routes: [
            GoRoute(
              path: 'chat/:chatId',
              name: 'chat',
              builder: (context, state) {
                final chatId = state.pathParameters['chatId']!;
                final extra = state.extra as Map<String, dynamic>?;
                return ChatScreen(
                  chatId: chatId,
                  otherUserName:
                      extra?['otherUserName'] as String? ?? 'Unknown',
                  otherUserAvatar: extra?['otherUserAvatar'] as String? ??
                      'assets/images/man.jpg',
                );
              },
            ),
          ],
        ),
        // Profile Tab
        GoRoute(
          path: '/dashboard/profile/edit',
          name: 'edit-profile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: '/dashboard/ads',
          name: 'ads',
          builder: (context, state) => const AdScreen(),
        ),
        GoRoute(
          path: '/dashboard/favorites',
          name: 'favorites',
          builder: (context, state) => const FavoriteScreen(),
        ),
        GoRoute(
          path: '/dashboard/subscription',
          name: 'subscription',
          builder: (context, state) => const SubscriptionScreen(),
        ),
        GoRoute(
          path: '/dashboard/feedback',
          name: 'feedback',
          builder: (context, state) => const FeedbackScreen(),
        ),
        GoRoute(
          path: '/dashboard/privacy-policy',
          name: 'privacy-policy',
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),
        GoRoute(
          path: '/dashboard/terms-conditions',
          name: 'terms-conditions',
          builder: (context, state) => const TermsConditionsScreen(),
        ),
        GoRoute(
          path: '/dashboard/account',
          name: 'account',
          builder: (context, state) => const AccountScreen(),
        ),
      ],
    ),

    // Redirect from old dashboard route to new one
    GoRoute(
      path: '/home-screen',
      redirect: (_, __) => '/dashboard/home',
    ),
  ],
  initialLocation: '/',
);
