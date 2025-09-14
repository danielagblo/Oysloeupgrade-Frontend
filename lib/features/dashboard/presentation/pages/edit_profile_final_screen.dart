import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:oysloe_mobile/core/common/widgets/appbar.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/common/widgets/input.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import '../widgets/ad_input.dart';

class EditProfileFinalScreen extends StatefulWidget {
  const EditProfileFinalScreen({super.key});

  @override
  State<EditProfileFinalScreen> createState() => _EditProfileFinalScreenState();
}

class _EditProfileFinalScreenState extends State<EditProfileFinalScreen> {
  // General details
  final _nameCtrl = TextEditingController(text: 'John Agblo');
  final _emailCtrl = TextEditingController(text: 'agblod27@gmail.com');
  final _firstNumberCtrl = TextEditingController(text: '0552892433');
  final _secondNumberCtrl = TextEditingController();
  final _nationalIdCtrl = TextEditingController(text: 'AgHDFKL34658');
  final _businessNameCtrl = TextEditingController(text: 'Another Phone');

  // Payment account
  final _accountNameCtrl = TextEditingController(text: 'Another Phone');
  final _accountNumberCtrl = TextEditingController(text: '0552892433');
  String? _selectedNetwork = 'MTN';

  bool _showSuccessCard = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _firstNumberCtrl.dispose();
    _secondNumberCtrl.dispose();
    _nationalIdCtrl.dispose();
    _businessNameCtrl.dispose();
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
        title: 'Edit profile',
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
                  if (_showSuccessCard)
                    _SuccessProgressCard(
                      onClose: () => setState(() => _showSuccessCard = false),
                      onPostAd: () {},
                    ),
                  if (_showSuccessCard) SizedBox(height: 2.2.h),
                  _AvatarAndLogoRow(),
                  SizedBox(height: 2.2.h),
                  Text(
                    'General Details',
                    style: AppTypography.body.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  const _FieldLabel('Name'),
                  AppTextField(
                    controller: _nameCtrl,
                    hint: 'Ex. John Agblo',
                    leadingSvgAsset: 'assets/icons/name.svg',
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.6.h),
                  Row(
                    children: const [
                      _FieldLabel('Email'),
                      SizedBox(width: 8),
                      _VerifiedChip(),
                    ],
                  ),
                  AppTextField(
                    controller: _emailCtrl,
                    hint: 'Email',
                    leadingSvgAsset: 'assets/icons/email.svg',
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.6.h),
                  const _FieldLabel('First number'),
                  AppTextField(
                    controller: _firstNumberCtrl,
                    hint: 'Number',
                    leadingSvgAsset: 'assets/icons/outgoing_call.svg',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.6.h),
                  const _FieldLabel('Second number'),
                  AppTextField(
                    controller: _secondNumberCtrl,
                    hint: 'Number',
                    leadingSvgAsset: 'assets/icons/outgoing_call.svg',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.6.h),
                  Row(
                    children: const [
                      _FieldLabel('National ID'),
                      SizedBox(width: 8),
                      _VerifiedChip(),
                    ],
                  ),
                  AppTextField(
                    controller: _nationalIdCtrl,
                    hint: 'ID number',
                    leadingSvgAsset: 'assets/icons/id.svg',
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.6.h),
                  const _FieldLabel('Business name'),
                  AppTextField(
                    controller: _businessNameCtrl,
                    hint: 'Add your business name?',
                    leadingSvgAsset: 'assets/icons/bag.svg',
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 2.2.h),
                  Text(
                    'Payment Account',
                    style: AppTypography.body.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  const _FieldLabel('Account name'),
                  AppTextField(
                    controller: _accountNameCtrl,
                    hint: 'Account name',
                    leadingSvgAsset: 'assets/icons/account_name.svg',
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.6.h),
                  const _FieldLabel('Account number'),
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
                      padding:
                          const EdgeInsetsDirectional.only(start: 24, end: 12),
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
                  SizedBox(height: 3.h),
                  CustomButton.filled(
                    label: 'Save changes',
                    onPressed: () {
                      Navigator.of(context).maybePop();
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

class _SuccessProgressCard extends StatelessWidget {
  const _SuccessProgressCard({required this.onClose, required this.onPostAd});
  final VoidCallback onClose;
  final VoidCallback onPostAd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(3.w, 1.0.h, 3.w, 1.6.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -18,
            right: -15,
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close, color: AppColors.blueGray374957),
              tooltip: 'Close',
              padding: const EdgeInsets.all(0),
              constraints: const BoxConstraints(),
              iconSize: 17,
            ),
          ),
          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const LinearProgressIndicator(
                  value: 1.0,
                  minHeight: 8,
                  backgroundColor: AppColors.grayF9,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              SizedBox(height: 1.2.h),
              Text(
                "You're set now 100%",
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.blueGray374957,
                ),
              ),
              SizedBox(height: 0.3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Congrats! Submit your first ad',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.blueGray374957,
                    ),
                  ),
                  CustomButton.capsule(
                    label: '+ Post Ad',
                    onPressed: onPostAd,
                    filled: true,
                    fillColor: AppColors.grayD9.withValues(alpha: 0.19),
                    textStyle: AppTypography.body
                        .copyWith(fontWeight: FontWeight.w500),
                    height: 36,
                    width: 120,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarAndLogoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Profile image
        Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                border: Border.all(color: AppColors.primary, width: 4),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/default_user.svg',
                width: 50,
                height: 50,
              ),
            ),
            SizedBox(height: 0.8.h),
            Text('Profile image', style: AppTypography.bodySmall),
          ],
        ),
        // Business logo
        Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                border: Border.all(color: AppColors.primary, width: 4),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/upload.svg',
                width: 28,
                height: 28,
              ),
            ),
            SizedBox(height: 0.8.h),
            Text('Business logo', style: AppTypography.bodySmall),
          ],
        ),
      ],
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

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
      decoration: BoxDecoration(
        color: Color(0xFF00ACFF),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        'Verified',
        style: AppTypography.bodySmall
            .copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
      ),
    );
  }
}
