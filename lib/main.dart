import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/routes/routers.dart';

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
        return MaterialApp.router(
          title: 'Oysloe Mobile',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(Brightness.light),
          darkTheme: buildAppTheme(Brightness.dark),
          routerConfig: appRouter,
        );
      },
    );
  }
}
