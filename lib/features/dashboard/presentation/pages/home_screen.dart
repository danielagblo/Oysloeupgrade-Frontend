import 'package:flutter/material.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/constants/body_paddings.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/search_input.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/categories_section.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/stats_section.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/ads_section.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oysloe'), centerTitle: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: BodyPaddings.horizontalPage,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 2.5.h),
              SearchInput(),
              SizedBox(height: 3.h),
              const CategoriesSection(),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Explore Ads',
                    style: AppTypography.bodyLarge.copyWith(fontSize: 17.sp),
                  ),
                  SizedBox(width: 3.w),
                  CustomButton.capsule(
                    label: 'Show All',
                    filled: true,
                    width: 25.w,
                    textColor: AppColors.blueGray374957,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              const StatsSection(),
              SizedBox(height: 3.h),
              const AdsSection(),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }
}
