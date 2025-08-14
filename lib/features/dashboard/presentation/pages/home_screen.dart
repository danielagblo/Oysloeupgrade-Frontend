import 'package:flutter/material.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayF9,
      appBar: AppBar(title: const Text('Home'), backgroundColor: AppColors.grayF9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('HOME SCREEN'),
          ],
        ),
      ),
    );
  }
}
