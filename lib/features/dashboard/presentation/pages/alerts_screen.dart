import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/core/common/widgets/appbar.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  bool get hasAlerts => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayF9,
      appBar: CustomAppBar(
        title: 'Alerts',
        actions: [
          Icon(
            Icons.more_vert,
            color: Color(0xFF817F7F),
            size: 24,
          )
        ],
      ),
      body: hasAlerts ? _buildAlertsContent() : _buildEmptyState(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/big_bell.png',
            width: 120,
            height: 120,
          ),
          SizedBox(height: 24),
          Text(
            'No notifications to show',
            style: AppTypography.body.copyWith(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blueGray374957,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'You currently do not have any notification yet.\nwe\'re going to notify you when \nsomething new happens',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                fontSize: 14.sp,
                color: AppColors.blueGray374957.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 16),
            children: [
                _AlertGroup(
                  title: 'Today',
                  alerts: [
                    _AlertData(
                      timeAgo: '10 mins ago',
                      title: 'Oysloe',
                      message: 'We\'re excited to have you onboard. You\'ve taken the first step toward smarter shopping and selling. Big things await — stay tuned!',
                      hasCustomProfile: false,
                    ),
                  ],
                ),
                SizedBox(height: 2.5.h),
                _AlertGroup(
                  title: 'Yesterday',
                  alerts: [
                    _AlertData(
                      timeAgo: '10 mins ago',
                      title: 'Oysloe',
                      message: 'Your subscription expires in 7 days',
                      hasCustomProfile: false,
                    ),
                    _AlertData(
                      timeAgo: '10 mins ago',
                      title: 'Oysloe',
                      message: 'Your subscription expires in 3 days',
                      hasCustomProfile: false,
                    ),
                    _AlertData(
                      timeAgo: '10 mins ago',
                      title: 'Oysloe',
                      message: 'Your subscription is expired Subscribe',
                      hasCustomProfile: false,
                      hasActionText: true,
                      actionText: 'Subscribe',
                    ),
                    _AlertData(
                      timeAgo: '10 mins ago',
                      title: 'Oysloe',
                      message: 'we hand picked few items for you show listings',
                      hasCustomProfile: false,
                      hasActionText: true,
                      actionText: 'show listings',
                    ),
                    _AlertData(
                      timeAgo: '10 mins ago',
                      title: 'Akosua Amassa',
                      message: 'Made a review on your ad Open',
                      profileImagePath: 'assets/images/man.jpg',
                      hasCustomProfile: true,
                      hasActionText: true,
                      actionText: 'Open',
                    ),
                    _AlertData(
                      timeAgo: '10 mins ago',
                      title: 'Oysloe',
                      message: 'We\'ve given you a free coupon,Your code to redeem is GH32432',
                      hasCustomProfile: false,
                    ),
                    _AlertData(
                      timeAgo: '10 mins ago',
                      title: 'Oysloe',
                      message: 'Your ad Samsung s6 ultra.. is reported as taken. Verify and update the status now!. Be informed you\'ll face suspension if there\'s multiple report on this ad.',
                      hasCustomProfile: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
}

class _AlertGroup extends StatelessWidget {
  const _AlertGroup({
    required this.title,
    required this.alerts,
  });

  final String title;
  final List<_AlertData> alerts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, bottom: 16),
          child: Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: Color(0xFF646161),
            ),
          ),
        ),
        ...alerts.map((alert) => _AlertTile(data: alert)),
      ],
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({
    required this.data,
  });

  final _AlertData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.grayD9.withValues(alpha:0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.timeAgo,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.gray8B959E,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${data.title} ',
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.blueGray374957,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextSpan(
                        text: data.hasActionText ? 
                          data.message.replaceAll(data.actionText ?? '', '') : data.message,
                        style: AppTypography.body.copyWith(
                          color: AppColors.blueGray374957,
                          fontSize: 14.sp,
                          height: 1.4,
                        ),
                      ),
                      if (data.hasActionText && data.actionText != null)
                        TextSpan(
                          text: data.actionText,
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.blueGray374957,
                            fontSize: 14.sp,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return data.hasCustomProfile && data.profileImagePath != null
        ? ClipOval(
            child: Image.asset(
              data.profileImagePath!,
              fit: BoxFit.cover,
              width: 32,
              height: 32,
            ),
          )
        : Center(
            child: SvgPicture.asset(
              'assets/icons/bk_logo.svg',
              width: 32,
              height: 32,
            ),
          );
  }
}

class _AlertData {
  const _AlertData({
    required this.timeAgo,
    required this.title,
    required this.message,
    required this.hasCustomProfile,
    this.profileImagePath,
    this.hasActionText = false,
    this.actionText,
  });

  final String timeAgo;
  final String title;
  final String message;
  final bool hasCustomProfile;
  final String? profileImagePath;
  final bool hasActionText;
  final String? actionText;
}
