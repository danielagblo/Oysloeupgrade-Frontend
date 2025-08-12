import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final double? width;

  final _CustomButtonType _type;

  final bool? filledIsPrimary;
  final String? leadingSvgAsset;

  final bool? capsuleFilled;
  final Color? capsuleFillColor;
  final Color? capsuleBorderColor;
  final Color? capsuleTextColor;

  const CustomButton._({
    required _CustomButtonType type,
    required this.onPressed,
    required this.label,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    this.width,
    this.filledIsPrimary,
    this.leadingSvgAsset,
    this.capsuleFilled,
    this.capsuleFillColor,
    this.capsuleBorderColor,
    this.capsuleTextColor,
    super.key,
  }) : _type = type;

  factory CustomButton.filled({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isPrimary = true,
    String? leadingSvgAsset,
    TextStyle? textStyle,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      vertical: 18,
      horizontal: 20,
    ),
    double? width,
  }) {
    return CustomButton._(
      key: key,
      type: _CustomButtonType.filled,
      label: label,
      onPressed: onPressed,
      filledIsPrimary: isPrimary,
      leadingSvgAsset: leadingSvgAsset,
      textStyle: textStyle,
      padding: padding,
      width: width,
    );
  }

  factory CustomButton.capsule({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool filled = false,
    Color? fillColor,
    Color? borderColor,
    Color? textColor,
    TextStyle? textStyle,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 18,
    ),
    double? width,
  }) {
    return CustomButton._(
      key: key,
      type: _CustomButtonType.capsule,
      label: label,
      onPressed: onPressed,
      capsuleFilled: filled,
      capsuleFillColor: fillColor,
      capsuleBorderColor: borderColor,
      capsuleTextColor: textColor,
      textStyle: textStyle,
      padding: padding,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _CustomButtonType.filled:
        return _buildFilled(context);
      case _CustomButtonType.capsule:
        return _buildCapsule(context);
    }
  }

  Widget _buildFilled(BuildContext context) {
    final bool isPrimary = filledIsPrimary ?? true;
    final theme = Theme.of(context);
    final bgColor = isPrimary ? AppColors.primary : AppColors.grayF9;
    final bool enabled = onPressed != null;
    final disabledTextColor = AppColors.blueGray374957.withValues(alpha: 0.33);
    final baseTextColor = isPrimary
        ? AppColors.gray222222
        : AppColors.blueGray374957;
    final txtColor = enabled
        ? baseTextColor
        : (isPrimary
              ? baseTextColor.withValues(alpha: 0.4)
              : disabledTextColor);
    final style =
        textStyle ??
        theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: txtColor,
        ) ??
        TextStyle(color: txtColor);

    final radius = BorderRadius.circular(20);

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingSvgAsset != null) ...[
          SvgPicture.asset(leadingSvgAsset!, width: 20, height: 20),
          SizedBox(width: 4.w),
        ],
        Flexible(
          child: Text(label, textAlign: TextAlign.center, style: style),
        ),
      ],
    );

    child = Padding(padding: padding, child: child);

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: width ?? double.infinity),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: enabled ? 1 : 0.7,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
            // border: Border.all(
            //   color: isPrimary ? Colors.transparent : AppColors.grayD9,
            //   width: 1,
            // ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: onPressed,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCapsule(BuildContext context) {
    final bool filled = capsuleFilled ?? false;
    final bool enabled = onPressed != null;
    final defaultOutlineColor = AppColors.grayBFBF.withValues(alpha: 0.29);
    final defaultFillColor = AppColors.grayD9.withValues(alpha: 0.19);

    final bgColor = filled
        ? (capsuleFillColor ?? defaultFillColor)
        : Colors.transparent;
    final borderColor = filled
        ? (capsuleBorderColor ?? Colors.transparent)
        : (capsuleBorderColor ?? defaultOutlineColor);
    final textColor =
        capsuleTextColor ??
        (filled ? AppColors.blueGray374957 : AppColors.blueGray374957);

    final theme = Theme.of(context);
    final style =
        textStyle ??
        theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor,
        ) ??
        TextStyle(color: textColor);

    final radius = BorderRadius.circular(1000);

    Widget child = Center(child: Text(label, style: style));
    child = Padding(padding: padding, child: child);

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: width ?? double.infinity),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: enabled ? 1 : 0.6,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: onPressed,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

enum _CustomButtonType { filled, capsule }
