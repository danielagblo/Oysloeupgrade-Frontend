import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/core/common/widgets/appbar.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final String _referralCode = 'DAN2785';

  void _showEarnInfoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EarnInfoBottomSheet(referralCode: _referralCode),
    );
  }

  void _showRedeemSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _RedeemBottomSheet(),
    );
  }

  void _showLevelInfoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _LevelInfoBottomSheet(),
    );
  }

  void _showPointsSummarySheet() {
    const transactions = [
      _PointsTransaction(date: 'Apr 7, 2024', points: 20, amount: 430),
      _PointsTransaction(date: 'Apr 7, 2024', points: 20, amount: 430),
      _PointsTransaction(date: 'Apr 7, 2024', points: 20, amount: 430),
      _PointsTransaction(date: 'Apr 7, 2024', points: 20, amount: 430),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PointsSummaryBottomSheet(
        cashEquivalent: 10,
        transactions: transactions,
      ),
    );
  }

  void _copyReferralCode() {
    Clipboard.setData(ClipboardData(text: _referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Referral code copied!'),
        backgroundColor: AppColors.blueGray374957,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayF9,
      appBar: const CustomAppBar(
        title: 'Refer and Earn',
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 1.2.h),
            _PointsCard(
              points: 10000,
              cashEquivalent: 10,
              onPointsTap: _showPointsSummarySheet,
              onEarnTap: _showEarnInfoSheet,
              onRedeemTap: _showRedeemSheet,
            ),
            SizedBox(height: 1.2.h),
            _LevelCard(
              currentLevel: 'Gold',
              progress: 0.9,
              pointsToNext: 9000,
              totalToNext: 100000,
              onInfoTap: _showLevelInfoSheet,
            ),
            SizedBox(height: 1.2.h),
            _ReferralSection(
              referralCode: _referralCode,
              onCopyTap: _copyReferralCode,
              friendsReferred: 0,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}

class _PointsCard extends StatelessWidget {
  final int points;
  final int cashEquivalent;
  final VoidCallback onPointsTap;
  final VoidCallback onEarnTap;
  final VoidCallback onRedeemTap;

  const _PointsCard({
    required this.points,
    required this.cashEquivalent,
    required this.onPointsTap,
    required this.onEarnTap,
    required this.onRedeemTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPoints = NumberFormat.decimalPattern().format(points);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: onPointsTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 22,
                  color: AppColors.primary,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Points',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      formattedPoints,
                      style: AppTypography.bodyLarge.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.3.h),
                    Text(
                      'equals ¢$cashEquivalent',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.blueGray374957.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 2.w),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.blueGray374957,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 1.2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Expanded(
                child: _ActionTile(
                  icon: 'assets/icons/earn.svg',
                  label: 'Earn',
                  onTap: onEarnTap,
                ),
              ),
              SizedBox(width: 2.5.w),
              Expanded(
                child: _ActionTile(
                  icon: 'assets/icons/redeem.svg',
                  label: 'Redeem',
                  onTap: onRedeemTap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.8.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  icon,
                  width: 24,
                  height: 24,
                ),
                SizedBox(height: 1.h),
                Text(
                  label,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.blueGray374957,
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String currentLevel;
  final double progress;
  final int pointsToNext;
  final int totalToNext;
  final VoidCallback onInfoTap;

  const _LevelCard({
    required this.currentLevel,
    required this.progress,
    required this.pointsToNext,
    required this.totalToNext,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final pointsText = NumberFormat.decimalPattern().format(pointsToNext);

    return GestureDetector(
        onTap: onInfoTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$currentLevel (Level)',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.blueGray374957,
                  ),
                ],
              ),
              SizedBox(height: 0.8.h),
              Text(
                '$pointsText points to diamond',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.blueGray374957.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 2.h),
              LayoutBuilder(
                builder: (context, constraints) {
                  final barWidth = constraints.maxWidth;
                  final progressWidth = (progress.clamp(0.0, 1.0)) * barWidth;
                  return Stack(
                    children: [
                      Container(
                        width: barWidth,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: progressWidth,
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.6),
                              AppColors.primary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class _ReferralSection extends StatelessWidget {
  final String referralCode;
  final VoidCallback onCopyTap;
  final int friendsReferred;

  const _ReferralSection({
    required this.referralCode,
    required this.onCopyTap,
    required this.friendsReferred,
  });

  @override
  Widget build(BuildContext context) {
    final referredText = NumberFormat.decimalPattern().format(friendsReferred);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Refer Your friends and Earn',
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          const _BenefitItem(
            icon: Icons.check_rounded,
            text: 'Pro Partnership status',
          ),
          const _BenefitItem(
            icon: Icons.check_rounded,
            text: 'All Ads stays promoted for a month',
          ),
          const _BenefitItem(
            icon: Icons.check_rounded,
            text: 'Share unlimited number of Ads',
          ),
          const _BenefitItem(
            icon: Icons.check_rounded,
            text: 'Boost your business',
          ),
          SizedBox(height: 2.4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppColors.grayF9,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    referralCode,
                    style: AppTypography.bodyLarge.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Copy',
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.4.h),
          Text(
            "You've referred $referredText friends",
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.blueGray374957.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsSummaryBottomSheet extends StatelessWidget {
  final int cashEquivalent;
  final List<_PointsTransaction> transactions;

  const _PointsSummaryBottomSheet({
    required this.cashEquivalent,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final formattedBalance =
        NumberFormat.decimalPattern().format(cashEquivalent);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.grayF9,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.6.h),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grayD9,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(6.w, 3.2.h, 6.w, 2.4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Redraw',
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.8.h),
                        Text(
                          'Balance: ¢$formattedBalance',
                          style: AppTypography.body.copyWith(
                            color:
                                AppColors.blueGray374957.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.4.h),
                  Text(
                    'Payment',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.gray222222.withValues(alpha: 0.72),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.6.h),
                  Text(
                    'Recent transactions',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.blueGray374957.withValues(alpha: 0.54),
                    ),
                  ),
                  SizedBox(height: 2.4.h),
                  if (transactions.isEmpty)
                    Text(
                      'No transactions yet.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.blueGray374957.withValues(alpha: 0.54),
                      ),
                    )
                  else
                    Column(
                      children: [
                        for (var i = 0; i < transactions.length; i++) ...[
                          _PointsTransactionRow(transaction: transactions[i]),
                          if (i != transactions.length - 1) ...[
                            SizedBox(height: 1.2.h),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.grayD9.withValues(alpha: 0.54),
                            ),
                            SizedBox(height: 1.2.h),
                          ],
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointsTransactionRow extends StatelessWidget {
  final _PointsTransaction transaction;

  const _PointsTransactionRow({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final amountText = NumberFormat.decimalPattern().format(transaction.amount);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            '${transaction.date} • ${transaction.points} points',
            style: AppTypography.bodySmall.copyWith(),
          ),
        ),
        Text(
          '¢$amountText',
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PointsTransaction {
  final String date;
  final int points;
  final int amount;

  const _PointsTransaction({
    required this.date,
    required this.points,
    required this.amount,
  });
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.blueGray374957,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.blueGray374957.withValues(alpha: 0.54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EarnInfoBottomSheet extends StatelessWidget {
  final String referralCode;
  const _EarnInfoBottomSheet({required this.referralCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.grayF9,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.6.h),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grayD9,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(6.w, 3.2.h, 6.w, 2.4.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'We value friendship',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.gray222222.withValues(alpha: 0.72),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Follow the steps below and get rewarded',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.blueGray374957.withValues(alpha: 0.54),
                    ),
                  ),
                  SizedBox(height: 3.2.h),
                  const _EarnStep(
                    step: 1,
                    title: 'Share your code',
                    icon: 'assets/icons/copy.svg',
                    isFirst: true,
                  ),
                  const _EarnStep(
                    step: 2,
                    title: 'Your friend adds the code',
                  ),
                  const _EarnStep(
                    step: 3,
                    title: 'Your friend places an order',
                    isLast: true,
                  ),
                  SizedBox(height: 2.6.h),
                  const _RewardItem(
                    icon: 'assets/icons/earn.svg',
                    title: 'You get',
                    subtitle: '50 Points',
                  ),
                  SizedBox(height: 1.8.h),
                  const _RewardItem(
                    icon: 'assets/icons/redeem.svg',
                    title: 'They get',
                    subtitle: 'Discount coupon 10% or 10 points',
                  ),
                  SizedBox(height: 3.4.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Color(0xFFBFBFBF).withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            referralCode,
                            style: AppTypography.bodyLarge.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 1.2.h),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Copy',
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.6.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarnStep extends StatelessWidget {
  final int step;
  final String title;
  final String? icon;
  final bool isFirst;
  final bool isLast;

  const _EarnStep({
    required this.step,
    required this.title,
    this.icon,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final connectorColor = AppColors.blueGray374957;
    final circleSize = 38.0;
    final connectorSpacing = 2.6.h;
    final connectorTail = 1.6.h;
    final topConnector = isFirst ? connectorTail : connectorSpacing / 2;
    final bottomConnector = isLast ? connectorTail : connectorSpacing / 2;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (topConnector > 0)
              Container(
                width: 1,
                height: topConnector,
                color: connectorColor,
              ),
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: connectorColor,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  '$step',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              height: bottomConnector,
              color: connectorColor,
            ),
          ],
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 0.8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    color: AppColors.blueGray374957.withValues(alpha: 0.54),
                  ),
                ),
                if (icon != null) ...[
                  SizedBox(width: 2.w),
                  SvgPicture.asset(
                    icon!,
                    width: 15,
                    height: 15,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RewardItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;

  const _RewardItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: const BoxDecoration(
            color: AppColors.grayF9,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(icon, width: 20, height: 20),
        ),
        SizedBox(width: 4.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.body.copyWith(
                fontSize: 14.sp,
                color: AppColors.blueGray374957.withValues(alpha: 0.54),
              ),
            ),
            Text(
              subtitle,
              style: AppTypography.body.copyWith(
                color: AppColors.gray222222.withValues(alpha: 0.72),
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RedeemBottomSheet extends StatefulWidget {
  const _RedeemBottomSheet();

  @override
  State<_RedeemBottomSheet> createState() => _RedeemBottomSheetState();
}

class _RedeemBottomSheetState extends State<_RedeemBottomSheet> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.grayF9,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.6.h),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grayD9,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(6.w, 3.2.h, 6.w, 2.4.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/redeem.svg',
                          width: 24, height: 24),
                      SizedBox(width: 2.4.w),
                      Text(
                        'Apply coupon',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.gray222222.withValues(alpha: 0.72),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.4.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColors.blueGray374957.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Get Cash equivalent',
                              style: AppTypography.body.copyWith(
                                color: AppColors.blueGray374957
                                    .withValues(alpha: 0.54),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '¢0',
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.2.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.grayF9,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _codeController,
                                  decoration: InputDecoration(
                                    hintText: 'Add code here',
                                    hintStyle: AppTypography.body.copyWith(
                                      color: AppColors.blueGray374957
                                          .withValues(alpha: 0.6),
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  style: AppTypography.body,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Coupon applied!'),
                                      backgroundColor: AppColors.blueGray374957,
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 1.2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.grayD9
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                  child: Text(
                                    'Apply',
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.6.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelInfoBottomSheet extends StatelessWidget {
  const _LevelInfoBottomSheet();

  @override
  Widget build(BuildContext context) {
    final tiers = [
      const _LevelTierCard(
        title: 'Silver',
        subtitle: '10 points to gold',
        progress: 0.12,
      ),
      const _LevelTierCard(
        title: 'Gold',
        subtitle: '100,000 points to gold',
        progress: 0.6,
      ),
      const _LevelTierCard(
        title: 'Diamond',
        subtitle: '1,000,000 points to diamond',
        progress: 1.0,
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.grayF9,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.6.h),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grayD9,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(4.5.w, 3.2.h, 4.5.w, 2.4.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < tiers.length; i++) ...[
                    tiers[i],
                    if (i != tiers.length - 1) SizedBox(height: 1.h),
                  ],
                  SizedBox(height: 3.h),
                  Text(
                    'Your earning levels also helps us to rank you.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.blueGray374957.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelTierCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  const _LevelTierCard({
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.8.h),
          Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.blueGray374957.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.6.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              final progressWidth = barWidth * clampedProgress;
              const barHeight = 8.0;

              return Stack(
                children: [
                  Container(
                    width: barWidth,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: (barHeight - 6) / 2,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  Container(
                    width: progressWidth,
                    height: barHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.75),
                          AppColors.primary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
