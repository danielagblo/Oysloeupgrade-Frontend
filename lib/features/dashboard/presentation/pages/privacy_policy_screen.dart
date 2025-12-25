import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:oysloe_mobile/core/common/widgets/adaptive_progress_indicator.dart';
import 'package:oysloe_mobile/core/common/widgets/appbar.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:oysloe_mobile/features/dashboard/domain/entities/privacy_policy_entity.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/privacy_policies/privacy_policies_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/privacy_policies/privacy_policies_state.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // PrivacyPoliciesCubit is provided at NavigationShell level
    return const _PrivacyPolicyView();
  }
}

class _PrivacyPolicyView extends StatelessWidget {
  const _PrivacyPolicyView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayF9,
      appBar: const CustomAppBar(
        title: 'Privacy Policy',
        backgroundColor: AppColors.white,
      ),
      body: BlocBuilder<PrivacyPoliciesCubit, PrivacyPoliciesState>(
        builder: (context, state) {
          if ((state.isLoading ||
                  state.status == PrivacyPoliciesStatus.initial) &&
              !state.hasData) {
            return const Center(child: AdaptiveProgressIndicator());
          }

          if (state.hasError) {
            return _ErrorView(
              message: state.message ?? 'Unable to load privacy policies.',
              onRetry: () =>
                  context.read<PrivacyPoliciesCubit>().fetch(forceRefresh: true),
            );
          }

          if (state.isSuccess && state.policies.isEmpty) {
            return const _EmptyPoliciesView();
          }

          final List<PrivacyPolicyEntity> policies = state.policies;

          return RefreshIndicator(
            color: AppColors.blueGray374957,
            onRefresh: () =>
                context.read<PrivacyPoliciesCubit>().fetch(forceRefresh: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(4.w),
              children: [
                ...policies.map(
                  (PrivacyPolicyEntity policy) => Padding(
                    padding: EdgeInsets.only(bottom: 1.2.h),
                    child: _PolicyTile(
                      policy: policy,
                      onTap: () => _showPolicySheet(context, policy),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Future<void> _showPolicySheet(
    BuildContext context,
    PrivacyPolicyEntity policy,
  ) {
    final double fixedHeight = MediaQuery.of(context).size.height * 0.7;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String dateLabel = _formatDate(policy.date);

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.translucent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: fixedHeight,
                child: SafeArea(
                  top: false,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.grayF9,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                            top: 1.2.h,
                            left: 4.w,
                            right: 4.w,
                            bottom: 1.2.h,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 44,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.grayD9,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.6.h),
                              Text(
                                policy.title,
                                style: AppTypography.body.copyWith(
                                  fontSize: 15.sp,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.blueGray374957,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.6.h),
                              Text(
                                'Dated: $dateLabel',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.blueGray374957
                                      .withValues(alpha: 0.6),
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(4.w, 1.6.h, 4.w, 2.4.h),
                            child: Text(
                              policy.body,
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 13.sp,
                                color: AppColors.blueGray374957
                                    .withValues(alpha: 0.8),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static String _formatDate(DateTime date) {
    if (date.millisecondsSinceEpoch == 0) {
      return 'Not available';
    }
    return DateFormat('MMM d, yyyy').format(date.toLocal());
  }
}

class _PolicyTile extends StatelessWidget {
  const _PolicyTile({
    required this.policy,
    required this.onTap,
  });

  final PrivacyPolicyEntity policy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String dateLabel = _PrivacyPolicyView._formatDate(policy.date);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.grayD9.withValues(alpha: 0.7),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 1.4.h,
            horizontal: 3.6.w,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      policy.title,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.blueGray374957,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 0.6.h),
                    Text(
                      'Dated: $dateLabel',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.blueGray374957.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.blueGray374957,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                color: AppColors.blueGray374957,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 2.h),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPoliciesView extends StatelessWidget {
  const _EmptyPoliciesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No privacy policies available.',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                color: AppColors.blueGray374957,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.8.h),
            Text(
              'Please check back later.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.blueGray374957.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
