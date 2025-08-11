import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oysloe_mobile/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:oysloe_mobile/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const OyesloeMobile());
}

class OyesloeMobile extends StatelessWidget {
  const OyesloeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Oysloe Mobile',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(Brightness.light),
          darkTheme: buildAppTheme(Brightness.dark),
          home: const SplashScreen(),
          routes: {
            '/onboarding': (context) => const OnboardingScreen(),
          },
        );
      },
    );
  }
}
