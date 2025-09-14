import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/core/common/widgets/appbar.dart';
import 'package:oysloe_mobile/core/common/widgets/input.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'edit_profile_final_screen.dart';
import '../widgets/ad_input.dart';

class SetPaymentAccountScreen extends StatefulWidget {
  const SetPaymentAccountScreen({super.key});

  @override
  State<SetPaymentAccountScreen> createState() =>
      _SetPaymentAccountScreenState();
}

class _SetPaymentAccountScreenState extends State<SetPaymentAccountScreen> {
  final _accountNameCtrl = TextEditingController();
  final _accountNumberCtrl = TextEditingController();
  String? _selectedNetwork;

  @override
  void dispose() {
    _accountNameCtrl.dispose();
    _accountNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayF9,
      appBar: const CustomAppBar(
        backgroundColor: AppColors.white,
        title: 'Set up',
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final horizontalPadding =
                maxWidth > 600 ? (maxWidth - 560) / 2 : 5.w;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _ProgressCard(percentage: 0.8),
                  SizedBox(height: 2.2.h),
                  Center(
                    child: Text(
                      'Set payment account',
                      style: AppTypography.body.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.2.h),
                  const _FieldLabel('Add account name'),
                  AppTextField(
                    controller: _accountNameCtrl,
                    hint: 'Account name',
                    leadingSvgAsset: 'assets/icons/account_name.svg',
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.6.h),
                  const _FieldLabel('Add account number'),
                  AppTextField(
                    controller: _accountNumberCtrl,
                    hint: 'Account number',
                    leadingSvgAsset: 'assets/icons/referral.svg',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.6.h),
                  const _FieldLabel('Mobile network'),
                  AdDropdown<String>(
                    value: _selectedNetwork,
                    onChanged: (v) => setState(() => _selectedNetwork = v),
                    hintText: 'Select mobile network',
                    compact: true,
                    prefixIcon: Padding(
                      padding: EdgeInsetsDirectional.only(start: 24, end: 12),
                      child: SvgPicture.asset(
                        'assets/icons/mobile_network.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'MTN', child: Text('MTN')),
                      DropdownMenuItem(
                          value: 'Vodafone', child: Text('Vodafone')),
                      DropdownMenuItem(
                          value: 'AirtelTigo', child: Text('AirtelTigo')),
                      DropdownMenuItem(value: 'Glo', child: Text('Glo')),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: Text(
                        'Skip',
                        style: AppTypography.body.copyWith(
                          color: AppColors.blueGray374957,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  CustomButton.filled(
                    label: 'Next',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EditProfileFinalScreen(),
                        ),
                      );
                    },
                    isPrimary: false,
                    backgroundColor: AppColors.white,
                    textStyle: AppTypography.body.copyWith(
                      color: AppColors.blueGray374957,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.percentage});
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.6.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: AppColors.grayD9.withValues(alpha: 0.35),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          SizedBox(height: 1.2.h),
          Text(
            'You are only ${(percentage * 100).round()}%',
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.blueGray374957,
            ),
          ),
          SizedBox(height: 0.3.h),
          Text(
            'Complete your account to upload your first ad',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.blueGray374957,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.6.h, left: 0.2.w),
      child: Text(
        text,
        style: AppTypography.body.copyWith(
          color: AppColors.blueGray374957,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
