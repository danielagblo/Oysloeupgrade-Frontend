import 'package:flutter/material.dart';
import 'package:oysloe_mobile/core/common/widgets/appbar.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Alerts', actions: [
        AppBarAction.svg(
          iconSize: 18,
          onTap: () {},
          svgAsset: 'assets/icons/alert.svg',
        ),
        AppBarAction.svg(
          iconSize: 18,
          onTap: () {},
          svgAsset: 'assets/icons/search.svg',
        ),
      ]),
    );
  }
}
