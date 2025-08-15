import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/common/widgets/input.dart';
import 'package:oysloe_mobile/core/constants/body_paddings.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isChecked = false;

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
                      "Get Started",
                      style: AppTypography.medium.copyWith(fontSize: 20.sp),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  AppTextField(
                    hint: "Name",
                    leadingSvgAsset: 'assets/icons/name.svg',
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 1.5.h),
                  AppTextField(
                    hint: "Email Address",
                    leadingSvgAsset: 'assets/icons/email.svg',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 1.5.h),
                  AppTextField(
                    hint: "+233",
                    leadingSvgAsset: 'assets/icons/phone.svg',
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 1.5.h),
                  AppTextField(
                    hint: "Password",
                    leadingSvgAsset: 'assets/icons/passwordkey.svg',
                    isPassword: true,
                  ),
                  SizedBox(height: 1.5.h),
                  AppTextField(
                    hint: "Retype Password",
                    leadingSvgAsset: 'assets/icons/passwordkey.svg',
                    isPassword: true,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'I have agreed to the ',
                          style: TextStyle(
                            color: AppColors.blueGray374957,
                            fontSize: 13.sp,
                          ),
                          children: [
                            TextSpan(
                              text: 'Privacy policy ',
                              style: TextStyle(
                                color: AppColors.blueGray374957,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            TextSpan(
                              text: 'and ',
                              style: TextStyle(color: AppColors.blueGray374957),
                            ),
                            TextSpan(
                              text: 'terms & conditions',
                              style: TextStyle(
                                color: AppColors.blueGray374957,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 2.w),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isChecked = !_isChecked;
                          });
                        },
                        child: Container(
                          width: 1.7.h,
                          height: 1.7.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isChecked
                                  ? AppColors.blueGray374957
                                  : AppColors.blueGray374957,
                              width: 1.5,
                            ),
                            color: _isChecked
                                ? AppColors.blueGray374957
                                : Colors.transparent,
                          ),
                          child: _isChecked
                              ? Icon(
                                  Icons.check,
                                  size: 12,
                                  color: AppColors.white,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  CustomButton.filled(
                    label: 'Sign up',
                    isPrimary: true,
                    onPressed: () {
                      context.pushNamed('referral-code');
                    },
                  ),
                  SizedBox(height: 2.5.h),
                  CustomButton.filled(
                    label: 'Sign up using google',
                    backgroundColor: AppColors.white,
                    leadingSvgAsset: 'assets/icons/google.svg',
                    isPrimary: false,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(
                      color: AppColors.blueGray374957,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: "Login",
                    style: TextStyle(
                      color: AppColors.blueGray374957,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.goNamed('login');
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
