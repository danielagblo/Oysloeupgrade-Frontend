import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/common/widgets/input.dart';
import 'package:oysloe_mobile/core/constants/body_paddings.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                      "Welcome!",
                      style: AppTypography.medium.copyWith(fontSize: 20.sp),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  AppTextField(
                    hint: "Email Address",
                    leadingSvgAsset: 'assets/icons/email.svg',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 2.h),
                  AppTextField(
                    hint: "Password",
                    leadingSvgAsset: 'assets/icons/passwordkey.svg',
                    isPassword: true,
                  ),
                  SizedBox(height: 5.h),
                  CustomButton.filled(
                    label: 'Login',
                    isPrimary: true,
                    onPressed: () {
                      context.pushNamed('home-screen');
                    },
                  ),
                  SizedBox(height: 2.5.h),
                  CustomButton.filled(
                    label: 'Login using google',
                    backgroundColor: AppColors.white,
                    leadingSvgAsset: 'assets/icons/google.svg',
                    isPrimary: false,
                    onPressed: () {},
                  ),
                  SizedBox(height: 3.h),
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
                        label: 'OTP Login',
                        filled: true,
                        fillColor: AppColors.white,
                        onPressed: () {
                          context.pushNamed('otp-login');
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
                        context.pushNamed('signup');
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
