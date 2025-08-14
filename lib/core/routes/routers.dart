import 'package:go_router/go_router.dart';
import 'package:oysloe_mobile/features/auth/presentation/pages/email_password_reset.dart';
import 'package:oysloe_mobile/features/auth/presentation/pages/login_screen.dart';
import 'package:oysloe_mobile/features/auth/presentation/pages/otp_login_screen.dart';
import 'package:oysloe_mobile/features/auth/presentation/pages/otp_verification_screen.dart';
import 'package:oysloe_mobile/features/auth/presentation/pages/referral_code_screen.dart';
import 'package:oysloe_mobile/features/auth/presentation/pages/signup_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/home_screen.dart';
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
      path: '/home-screen',
      name: 'home-screen',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      name: 'otp-verification',
      builder: (context, state) => const OtpVerificationScreen(),
    ),
  ],
  initialLocation: '/',
);
