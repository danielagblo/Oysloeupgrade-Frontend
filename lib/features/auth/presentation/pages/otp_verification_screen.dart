import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/constants/body_paddings.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:oysloe_mobile/features/auth/presentation/widgets/otp_code_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayF9,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.grayF9,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: BodyPaddings.horizontalPage,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    child: Text(
                      "OTP Login",
                      style: AppTypography.medium.copyWith(fontSize: 20.sp),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  OtpCodeInput(length: 6),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: BodyPaddings.large,
                    ),
                    child: Text(
                      "Enter the OTP sent to your phone number.",
                      style: AppTypography.body.copyWith(
                        fontSize: 15.sp,
                        color: Color(0xFF646161),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  CustomButton.filled(
                    label: 'Verify',
                    isPrimary: true,
                    onPressed: () {
                      context.pushNamed('home-screen');
                    },
                  ),
                  SizedBox(height: 2.5.h),
                  Text('Can\'t login?'),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton.capsule(
                        label: 'Password Reset',
                        filled: true,
                        fillColor: AppColors.white,
                        onPressed: () {
                          context.pushNamed('email-password-reset');
                        },
                      ),
                      SizedBox(width: 5.w),
                      CustomButton.capsule(
                        label: 'Login',
                        filled: true,
                        fillColor: AppColors.white,
                        onPressed: () {
                          context.goNamed('login');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: AppColors.blueGray374957,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: "Sign Up",
                    style: TextStyle(
                      color: AppColors.blueGray374957,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.goNamed('signup');
                      },
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.5.h),
          ],
        ),
      ),
    );
  }
}

