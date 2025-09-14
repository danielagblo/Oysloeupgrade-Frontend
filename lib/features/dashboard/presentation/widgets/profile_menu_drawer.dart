import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:go_router/go_router.dart';

/// A right-side drawer shown when tapping the Profile tab.
/// Width is set by the parent via a SizedBox; this widget focuses on content.
class ProfileMenuDrawer extends StatelessWidget {
  const ProfileMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final radius = 24.0;
    return Drawer(
      backgroundColor: AppColors.grayF9,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: ListView(
            children: [
              // Logout Row
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  color: AppColors.grayD9.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: SvgPicture.asset('assets/icons/logout.svg'),
                    ),
                    SizedBox(width: 1.w),
                    Text('Logout', style: AppTypography.body),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Profile card
              _ProfileHeaderCard(),

              SizedBox(height: 2.5.h),

              // Stats
              Row(
                children: const [
                  Expanded(
                      child: _StatCard(title: 'Active Ads', value: '900k')),
                  SizedBox(width: 12),
                  Expanded(child: _StatCard(title: 'Taken Ads', value: '900k')),
                ],
              ),

              SizedBox(height: 3.h),

              _SectionHeader('Account'),
              _MenuTile(
                iconPath: 'assets/icons/name.svg',
                title: 'Edit profile',
                onTap: () {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    router.pushNamed('edit-profile');
                  });
                },
              ),

              SizedBox(height: 2.h),
              _SectionHeader('Business'),
              _MenuTile(
                iconPath: 'assets/icons/ads.svg',
                title: 'Ads',
                onTap: () {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    router.pushNamed('ads');
                  });
                },
              ),
              _MenuTile(
                iconPath: 'assets/icons/bookmark.svg',
                title: 'Favorite',
                onTap: () {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    router.pushNamed('favorites');
                  });
                },
              ),
              _MenuTile(
                iconPath: 'assets/icons/subscription.svg',
                title: 'Subscription',
                onTap: () {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    router.pushNamed('subscription');
                  });
                },
              ),
              _MenuTile(
                iconPath: 'assets/icons/refer_earn.svg',
                title: 'Refer & Earn',
                onTap: () {},
              ),

              SizedBox(height: 2.h),
              _SectionHeader('Settings'),
              _MenuTile(
                iconPath: 'assets/icons/feedback.svg',
                title: 'Feedback',
                onTap: () {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    router.pushNamed('feedback');
                  });
                },
              ),
              _MenuTile(
                iconPath: 'assets/icons/account.svg',
                title: 'Account',
                onTap: () {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    router.pushNamed('account');
                  });
                },
              ),
              _MenuTile(
                iconPath: 'assets/icons/tnc.svg',
                title: 'T&C',
                onTap: () {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    router.pushNamed('terms-conditions');
                  });
                },
              ),
              _MenuTile(
                iconPath: 'assets/icons/privacy_policy.svg',
                title: 'Privacy policy',
                onTap: () {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    router.pushNamed('privacy-policy');
                  });
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.sp, horizontal: 14.sp),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              border: Border.all(color: AppColors.primary, width: 5),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/images/default_user.svg',
              width: 39,
              height: 39,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jeffery Andoff',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blueGray374957)),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: AppColors.blueGray374957,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text('High Level', style: AppTypography.bodySmall),
                  ],
                ),
                SizedBox(height: 0.8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: 0.7,
                    backgroundColor: AppColors.grayD9.withValues(alpha: 0.5),
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style:
                AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 0.5.h),
          Text(title,
              style: AppTypography.bodySmall.copyWith(
                  color: AppColors.blueGray263238.withValues(alpha: 0.42))),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        title,
        style: AppTypography.body
            .copyWith(color: Colors.black.withValues(alpha: 0.47)),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback? onTap;

  const _MenuTile({
    required this.iconPath,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 37,
        height: 37,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(iconPath, width: 18, height: 18),
      ),
      title: Text(title, style: AppTypography.body),
      onTap: onTap,
    );
  }
}
