import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:oysloe_mobile/core/common/widgets/animated_gradient_search_input.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/categories_section.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/stats_section.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/ads_section.dart';
import 'package:oysloe_mobile/core/routes/routes.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/products/products_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/categories/categories_cubit.dart';
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
            child: RefreshIndicator(
              color: AppColors.blueGray374957,
              onRefresh: () async {
                await Future.wait<void>([
                  context.read<ProductsCubit>().fetch(),
                  context
                      .read<CategoriesCubit>()
                      .fetch(forceRefresh: true),
                ]);
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 2.5.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return AnimatedOpacity(
                              opacity: 1.0 -
                                  (_animation.value * 1.2).clamp(0.0, 1.0),
                              duration: const Duration(milliseconds: 200),
                              child: Transform.translate(
                                offset: Offset(0, _animation.value * -15),
                                child: _buildFullSearch(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: CategoriesSection(
                          onCategoryTap: (categoryId, label) {
                            final String normalizedLabel =
                                label.trim().toLowerCase();

                            if (normalizedLabel == 'services') {
                              context.pushNamed(
                                AppRouteNames.dashboardServices,
                              );
                              return;
                            }

                            context.pushNamed(
                              AppRouteNames.dashboardCategoryAds,
                              extra: <String, dynamic>{
                                'label': label,
                                'categoryId': categoryId,
                              },
                            );
                          },
                        ),
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
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF3F3F3),
                              foregroundColor: AppColors.grayD9,
                              elevation: 0,
                              textStyle: AppTypography.body.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text(
                              'Show All',
                              style: AppTypography.body.copyWith(
                                color: AppColors.blueGray374957,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: const StatsSection(),
                      ),
                      SizedBox(height: 3.h),
                      const AdsSection(),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullSearch() {
    return AnimatedGradientSearchInput.full(
      controller: _searchController,
    );
  }

  Widget _buildCompactSearch() {
    return AnimatedGradientSearchInput.compact(
      controller: _searchController,
    );
  }
}
