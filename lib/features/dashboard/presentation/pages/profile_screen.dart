import 'package:flutter/material.dart';
import 'package:oysloe_mobile/core/common/widgets/appbar.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      backgroundColor: AppColors.grayF9,
      appBar: CustomAppBar(
        title: 'Profile',
        backgroundColor: AppColors.white,
      ),
      body: Center(
        child: Text(
          'Profile Screen',
          style: AppTypography.body.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.blueGray374957,
          ),
        ),
      ),
    );
  }
}