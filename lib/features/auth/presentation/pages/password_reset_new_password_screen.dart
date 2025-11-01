import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oysloe_mobile/core/common/widgets/app_snackbar.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/common/widgets/input.dart';
import 'package:oysloe_mobile/core/constants/body_paddings.dart';
import 'package:oysloe_mobile/core/routes/routes.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:oysloe_mobile/core/usecase/reset_password_params.dart';
import 'package:oysloe_mobile/core/utils/validator.dart';
import 'package:oysloe_mobile/features/auth/presentation/bloc/password_reset/password_reset_cubit.dart';
import 'package:oysloe_mobile/features/auth/presentation/bloc/password_reset/password_reset_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PasswordResetNewPasswordScreen extends StatefulWidget {
  const PasswordResetNewPasswordScreen({
    super.key,
    required this.phone,
    required this.otp,
  });

  final String phone;
  final String otp;

  @override
  State<PasswordResetNewPasswordScreen> createState() =>
      _PasswordResetNewPasswordScreenState();
}

class _PasswordResetNewPasswordScreenState
    extends State<PasswordResetNewPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(PasswordResetCubit cubit) {
    if (!_formKey.currentState!.validate()) {
      showErrorSnackBar(context, 'Please correct the highlighted fields.');
      return;
    }

    FocusScope.of(context).unfocus();

    final ResetPasswordParams params = ResetPasswordParams(
      email: _emailController.text.trim(),
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
    cubit.resetPassword(params);
  }

  @override
  Widget build(BuildContext context) {
    final PasswordResetCubit cubit = context.read<PasswordResetCubit>();

    return BlocConsumer<PasswordResetCubit, PasswordResetState>(
      listener: (BuildContext context, PasswordResetState state) {
        if (state is PasswordResetError) {
          showErrorSnackBar(context, state.message);
        } else if (state is PasswordResetSuccess) {
          showSuccessSnackBar(
              context,
              state.response.message.isNotEmpty
                  ? state.response.message
                  : 'Password updated successfully.');
          context.goNamed(AppRouteNames.login);
        }
      },
      builder: (BuildContext context, PasswordResetState state) {
        final bool isSubmitting = state is PasswordResetSubmitting;

        return Scaffold(
          backgroundColor: AppColors.grayF9,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: AppColors.grayF9,
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: BodyPaddings.horizontalPage,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          child: Text(
                            'Create new password',
                            style:
                                AppTypography.medium.copyWith(fontSize: 20.sp),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AppTextField(
                          controller: _emailController,
                          hint: 'Email Address',
                          leadingSvgAsset: 'assets/icons/email.svg',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !isSubmitting,
                          validator: (String? value) {
                            final String? emptyCheck =
                                CustomValidator.isNotEmpty(value ?? '');
                            if (emptyCheck != null) return emptyCheck;
                            return CustomValidator.validateEmail(value ?? '');
                          },
                        ),
                        SizedBox(height: 2.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Use the email linked to your account.',
                            style: AppTypography.bodySmall.copyWith(
                              color: const Color(0xFF646161),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        AppTextField(
                          controller: _newPasswordController,
                          hint: 'New Password',
                          leadingSvgAsset: 'assets/icons/passwordkey.svg',
                          isPassword: true,
                          textInputAction: TextInputAction.next,
                          enabled: !isSubmitting,
                          validator: (String? value) {
                            final String? emptyCheck =
                                CustomValidator.isNotEmpty(value ?? '');
                            if (emptyCheck != null) return emptyCheck;
                            return CustomValidator.validatePassword(
                              value ?? '',
                            );
                          },
                        ),
                        SizedBox(height: 2.h),
                        AppTextField(
                          controller: _confirmPasswordController,
                          hint: 'Confirm Password',
                          leadingSvgAsset: 'assets/icons/passwordkey.svg',
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          enabled: !isSubmitting,
                          validator: (String? value) {
                            final String? emptyCheck =
                                CustomValidator.isNotEmpty(value ?? '');
                            if (emptyCheck != null) return emptyCheck;
                            return CustomValidator.validatePasswordFields(
                              _newPasswordController.text,
                              value ?? '',
                            );
                          },
                        ),
                        SizedBox(height: 5.h),
                        CustomButton.filled(
                          label: 'Update Password',
                          isPrimary: true,
                          onPressed: isSubmitting ? null : () => _submit(cubit),
                          isLoading: isSubmitting,
                        ),
                        SizedBox(height: 3.h),
                        CustomButton.capsule(
                          label: 'Back to Login',
                          filled: true,
                          fillColor: AppColors.white,
                          onPressed: isSubmitting
                              ? null
                              : () {
                                  context.goNamed(AppRouteNames.login);
                                },
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: AppColors.blueGray374957,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: AppColors.blueGray374957,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (isSubmitting) return;
                              context.goNamed(AppRouteNames.signup);
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.5.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
