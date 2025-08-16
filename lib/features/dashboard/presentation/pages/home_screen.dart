import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/constants/body_paddings.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/categories_section.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/stats_section.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/ads_section.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AnimatedHomeScreen extends StatefulWidget {
  const AnimatedHomeScreen({super.key});

  @override
  State<AnimatedHomeScreen> createState() => _AnimatedHomeScreenState();
}

class _AnimatedHomeScreenState extends State<AnimatedHomeScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _showAppBarSearch = false;
  static const double _scrollThreshold = 80.0;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final shouldShow = offset > _scrollThreshold;

    if (_showAppBarSearch != shouldShow) {
      setState(() {
        _showAppBarSearch = shouldShow;
      });

      if (shouldShow) {
        _animationController.forward();
        HapticFeedback.lightImpact();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        left: _animation.value > 0 ? 0 : null,
                        right: _animation.value > 0 ? null : 0,
                        top: 0,
                        bottom: 0,
                        width: _animation.value > 0
                            ? null
                            : MediaQuery.of(context).size.width - (8.w),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          alignment: _animation.value > 0
                              ? Alignment.centerLeft
                              : Alignment.center,
                          child: Text(
                            'Oysloe',
                            style: AppTypography.bodyLarge.copyWith(
                              fontSize: (21 - (_animation.value * 2)).sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // Animated search in app bar
                      if (_animation.value > 0)
                        Positioned(
                          left: 105,
                          right: 0,
                          top: 11,
                          bottom: 11,
                          child: Transform.scale(
                            scale: _animation.value,
                            alignment: Alignment.centerLeft,
                            child: Opacity(
                              opacity: _animation.value,
                              child: _buildCompactSearch(),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          // Body content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: BodyPaddings.horizontalPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 2.5.h),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return AnimatedOpacity(
                          opacity:
                              1.0 - (_animation.value * 1.2).clamp(0.0, 1.0),
                          duration: const Duration(milliseconds: 200),
                          child: Transform.translate(
                            offset: Offset(0, _animation.value * -15),
                            child: _buildFullSearch(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 3.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                      child: const CategoriesSection(),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Explore Ads',
                          style: AppTypography.bodyLarge.copyWith(
                            fontSize: 17.sp,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        CustomButton.capsule(
                          label: 'Show All',
                          filled: true,
                          width: 22.w,
                          height: 4.5.h,
                          textStyle: AppTypography.body.copyWith(
                            color: AppColors.blueGray374957,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    const StatsSection(),
                    SizedBox(height: 3.h),
                    const AdsSection(),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullSearch() {
    final BorderRadius radius = BorderRadius.circular(32);
    final Color innerColor =
        Theme.of(context).inputDecorationTheme.fillColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppColors.blueGray374957
            : AppColors.white);

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: radius,
      ),
      padding: const EdgeInsets.all(1.8),
      child: Container(
        decoration: BoxDecoration(color: innerColor, borderRadius: radius),
        child: TextField(
          controller: _searchController,
          style: AppTypography.body,
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search anything up for good',
            hintStyle: AppTypography.body,
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIconConstraints: const BoxConstraints(minWidth: 48),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactSearch() {
    final BorderRadius radius = BorderRadius.circular(24);
    final Color innerColor =
        Theme.of(context).inputDecorationTheme.fillColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppColors.blueGray374957
            : AppColors.white);

    return Container(
      height: 38,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: radius,
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        decoration: BoxDecoration(color: innerColor, borderRadius: radius),
        child: TextField(
          controller: _searchController,
          style: AppTypography.body.copyWith(fontSize: 14.sp),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search anything up for good',
            hintStyle: AppTypography.body.copyWith(
              fontSize: 13.sp,
              color: Theme.of(context).hintColor.withValues(alpha: 0.7),
            ),
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIconConstraints: const BoxConstraints(minWidth: 36),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 15,
                height: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
