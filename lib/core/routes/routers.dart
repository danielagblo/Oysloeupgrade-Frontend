import 'package:flutter/material.dart';
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
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/ad_card.dart';
import 'package:oysloe_mobile/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:oysloe_mobile/features/onboarding/presentation/pages/onboarding_flow.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), automaticallyImplyLeading: false),
      body: Center(
        child: Text(
          '$title Screen',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

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
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Post Ad'),
        ),

        // Inbox Tab
        GoRoute(
          path: '/dashboard/inbox',
          name: 'inbox',
          builder: (context, state) => const InboxScreen(),
        ),

        // Profile Tab
        GoRoute(
          path: '/dashboard/profile',
          name: 'profile',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Profile'),
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
