import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/core/common/widgets/appbar.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';

enum SubscriptionPlan { basic, business, platinum }

enum SubscriptionStatus { none, active, expired }

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // Mock subscription status - change this to test different states
  SubscriptionStatus _subscriptionStatus = SubscriptionStatus.none;
  SubscriptionPlan? _currentPlan;
  int _daysRemaining = 7;

  // Selected plan for purchase
  SubscriptionPlan? _selectedPlan;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionStatus();
  }

  void _loadSubscriptionStatus() {
    setState(() {
      _subscriptionStatus = SubscriptionStatus.active;
      _currentPlan = SubscriptionPlan.basic;
      _daysRemaining = 7;
    });
  }

  void _selectPlan(SubscriptionPlan plan) {
    setState(() {
      _selectedPlan = plan;
    });
  }

  void _handlePayment() {
    if (_selectedPlan == null &&
        _subscriptionStatus != SubscriptionStatus.active) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a subscription plan'),
          backgroundColor: AppColors.redFF6B6B,
        ),
      );
      return;
    }

    // Handle payment logic here
    // Navigate to payment gateway or process payment
    debugPrint('Processing payment for ${_selectedPlan.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayF9,
      appBar: const CustomAppBar(
        title: 'Subscription',
        backgroundColor: AppColors.white,
      ),
      body: _subscriptionStatus == SubscriptionStatus.active &&
              _currentPlan != null
          ? _buildActiveSubscriptionView()
          : _buildNoSubscriptionView(),
    );
  }

  Widget _buildNoSubscriptionView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choose a monthly plan that works for you',
              style: AppTypography.body.copyWith(
                fontSize: 16.sp,
                color: AppColors.blueGray374957.withValues(alpha: 0.54),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),

            // Basic Plan
            _SubscriptionCard(
              plan: SubscriptionPlan.basic,
              title: 'Basic',
              multiplier: '1.5x',
              price: '₵ 567',
              originalPrice: '₵ 567',
              features: [
                'Share limited number of ads',
                'All ads stays promoted for a week',
              ],
              isSelected: _selectedPlan == SubscriptionPlan.basic,
              onTap: () => _selectPlan(SubscriptionPlan.basic),
              hasDiscount: true,
              discountText: 'For you 50% off',
            ),

            SizedBox(height: 2.h),

            // Business Plan
            _SubscriptionCard(
              plan: SubscriptionPlan.business,
              title: 'Business',
              multiplier: '4x',
              price: '₵ 567',
              originalPrice: '₵ 567',
              features: [
                'Pro partnership status',
                'All ads stays promoted for a month',
              ],
              isSelected: _selectedPlan == SubscriptionPlan.business,
              onTap: () => _selectPlan(SubscriptionPlan.business),
            ),

            SizedBox(height: 2.h),

            // Platinum Plan
            _SubscriptionCard(
              plan: SubscriptionPlan.platinum,
              title: 'Platinum',
              multiplier: '10x',
              price: '₵ 567',
              originalPrice: '₵ 567',
              features: [
                'Unlimited number of ads',
                'Sell 10x faster in all categories',
              ],
              isSelected: _selectedPlan == SubscriptionPlan.platinum,
              onTap: () => _selectPlan(SubscriptionPlan.platinum),
            ),

            SizedBox(height: 4.h),

            // Pay Now Button
            CustomButton.filled(
              label: 'Pay Now',
              onPressed: _handlePayment,
              backgroundColor: AppColors.white,
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSubscriptionView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Success Illustration and Status
            _ActiveSubscriptionHeader(
              planName: _getPlanName(_currentPlan!),
              daysRemaining: _daysRemaining,
            ),

            SizedBox(height: 3.h),

            // Current Plan (highlighted)
            _SubscriptionCard(
              plan: SubscriptionPlan.basic,
              title: 'Basic',
              multiplier: '1.5x',
              price: '₵ 567',
              originalPrice: '₵ 567',
              features: [
                'Share limited number of ads',
                'All ads stays promoted for a week',
              ],
              isSelected: true,
              isCurrentPlan: true,
              onTap: () {},
              hasDiscount: true,
              discountText: 'For you 50% off',
            ),

            SizedBox(height: 2.h),

            // Business Plan
            _SubscriptionCard(
              plan: SubscriptionPlan.business,
              title: 'Business',
              multiplier: '4x',
              price: '₵ 567',
              originalPrice: '₵ 567',
              features: [
                'Pro partnership status',
                'All ads stay promoted for 2 weeks',
              ],
              isSelected: _selectedPlan == SubscriptionPlan.business,
              onTap: () => _selectPlan(SubscriptionPlan.business),
            ),

            SizedBox(height: 2.h),

            // Platinum Plan
            _SubscriptionCard(
              plan: SubscriptionPlan.platinum,
              title: 'Platinum',
              multiplier: '10x',
              price: '₵ 567',
              originalPrice: '₵ 567',
              features: [
                'Unlimited number of ads',
                'Sell 10x faster in all categories',
              ],
              isSelected: _selectedPlan == SubscriptionPlan.platinum,
              onTap: () => _selectPlan(SubscriptionPlan.platinum),
            ),

            SizedBox(height: 4.h),

            // Pay Now Button
            CustomButton.filled(
              label: 'Pay Now',
              onPressed: _handlePayment,
              backgroundColor: AppColors.white,
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String _getPlanName(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.basic:
        return 'Basic package';
      case SubscriptionPlan.business:
        return 'Business package';
      case SubscriptionPlan.platinum:
        return 'Platinum package';
    }
  }
}

class _ActiveSubscriptionHeader extends StatelessWidget {
  final String planName;
  final int daysRemaining;

  const _ActiveSubscriptionHeader({
    required this.planName,
    required this.daysRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.7.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Title + chips
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're currently subscribed",
                  style: AppTypography.body.copyWith(
                    fontSize: 16.sp,
                    color: AppColors.blueGray374957,
                  ),
                ),
                SizedBox(height: 1.2.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Plan chip (green)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 0.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        planName,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.blueGray374957,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Expiry chip (light gray)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 0.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grayF9,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Expires in $daysRemaining days',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.blueGray374957,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          // Right: Cheers illustration
          SizedBox(
            height: 12.h,
            width: 18.w,
            child: SvgPicture.asset(
              'assets/images/cheers.svg',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final String title;
  final String multiplier;
  final String price;
  final String originalPrice;
  final List<String> features;
  final bool isSelected;
  final bool isCurrentPlan;
  final VoidCallback onTap;
  final bool hasDiscount;
  final String? discountText;

  const _SubscriptionCard({
    required this.plan,
    required this.title,
    required this.multiplier,
    required this.price,
    required this.originalPrice,
    required this.features,
    required this.isSelected,
    required this.onTap,
    this.isCurrentPlan = false,
    this.hasDiscount = false,
    this.discountText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 1.5.w, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected || isCurrentPlan
                    ? AppColors.blueGray374957
                    : Colors.transparent,
                width: isSelected || isCurrentPlan ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Multiplier
                Row(
                  children: [
                    Text(
                      title,
                      style: AppTypography.body.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blueGray374957,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grayF9,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        multiplier,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blueGray374957,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Features
                ...features.map((feature) => Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check,
                            size: 18,
                            color: AppColors.blueGray374957,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              feature,
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.blueGray374957
                                    .withValues(alpha: 0.54),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                SizedBox(height: 1.h),

                // Price
                Row(
                  children: [
                    Text(
                      price,
                      style: AppTypography.body.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blueGray374957,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      originalPrice,
                      style: AppTypography.body.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.gray8B959E,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.gray8B959E,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Discount Badge
          if (hasDiscount && discountText != null)
            Positioned(
              top: -10,
              right: 40,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 0.8.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blueGray374957,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  discountText!,
                  style: AppTypography.bodySmall.copyWith(
                    color: Color(0xFFDEFEED),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
