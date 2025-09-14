import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/core/common/widgets/appbar.dart';
import 'package:oysloe_mobile/core/common/widgets/input.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'set_payment_account_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _businessNameCtrl = TextEditingController();
  final _firstNumberCtrl = TextEditingController(text: '0552892433');
  final _secondNumberCtrl = TextEditingController();
  final _nationalIdCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _businessNameCtrl.dispose();
    _firstNumberCtrl.dispose();
    _secondNumberCtrl.dispose();
    _nationalIdCtrl.dispose();
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
                  _ProgressCard(percentage: 0.6),
                  SizedBox(height: 2.2.h),
                  _AvatarAndLogoRow(),
                  SizedBox(height: 2.2.h),
                  _FieldLabel('Name *'),
                  AppTextField(
                    controller: _nameCtrl,
                    hint: 'Ex. John Agblo',
                    leadingSvgAsset: 'assets/icons/name.svg',
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.6.h),
                  _FieldLabel('Business name'),
                  AppTextField(
                    controller: _businessNameCtrl,
                    hint: 'Add your business name?',
                    leadingSvgAsset: 'assets/icons/bag.svg',
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.6.h),
                  _FieldLabel('First number'),
                  AppTextField(
                    controller: _firstNumberCtrl,
                    hint: 'Number',
                    leadingSvgAsset: 'assets/icons/outgoing_call.svg',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.6.h),
                  _FieldLabel('Second number'),
                  AppTextField(
                    controller: _secondNumberCtrl,
                    hint: 'Number',
                    leadingSvgAsset: 'assets/icons/outgoing_call.svg',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.6.h),
                  _FieldLabel('Add national ID *'),
                  AppTextField(
                    controller: _nationalIdCtrl,
                    hint: 'ID number',
                    leadingSvgAsset: 'assets/icons/id.svg',
                    textInputAction: TextInputAction.next,
                    compact: true,
                  ),
                  SizedBox(height: 1.2.h),
                  _IDUploadPair(),
                  SizedBox(height: 2.2.h),
                  _VerifyEmailCard(email: 'agblod27@gmail.com'),
                  SizedBox(height: 2.2.h),
                  CustomButton.filled(
                    label: 'Next',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SetPaymentAccountScreen(),
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

class _AvatarAndLogoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _UploadCircle(label: 'Profile image'),
        _UploadCircle(label: 'Business logo'),
      ],
    );
  }
}

class _UploadCircle extends StatelessWidget {
  const _UploadCircle({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Text(label, style: AppTypography.bodySmall),
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

class _IDUploadPair extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SquareUpload(title: 'Front', size: 20.w),
        SizedBox(width: 3.w),
        _SquareUpload(title: 'Back', size: 20.w),
      ],
    );
  }
}

class _SquareUpload extends StatelessWidget {
  const _SquareUpload({required this.title, this.size});
  final String title;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final double boxSize = size ?? 26.w;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0, bottom: 8),
          child: Text(title, style: AppTypography.bodySmall),
        ),
        SizedBox(
          width: boxSize,
          height: boxSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppColors.grayD9.withValues(alpha: 0.6)),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/image.svg',
                width: 25,
                height: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VerifyEmailCard extends StatelessWidget {
  const _VerifyEmailCard({required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.4.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Please verify your email*',
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.blueGray374957,
            ),
          ),
          SizedBox(height: 0.8.h),
          Text(
            'We will send an email to $email\nClick the link in the email to verify your account',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.blueGray374957.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.6.h),
          CustomButton.capsule(
            label: 'Send link',
            onPressed: () {},
            filled: true,
            fillColor: AppColors.grayD9.withValues(alpha: 0.19),
            textStyle: AppTypography.body.copyWith(
              fontWeight: FontWeight.w500,
            ),
            width: 160,
            height: 44,
          ),
        ],
      ),
    );
  }
}
