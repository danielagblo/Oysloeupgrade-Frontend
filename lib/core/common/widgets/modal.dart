import 'package:flutter/material.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppModalAction {
  final String label;
  final VoidCallback? onPressed;

  final bool filled;

  final Color? fillColor;
  final Color? borderColor;
  final Color? textColor;
  final String? trailingSvgAsset;

  const AppModalAction({
    required this.label,
    this.onPressed,
    this.filled = false,
    this.fillColor,
    this.borderColor,
    this.textColor,
    this.trailingSvgAsset,
  });
}


class AppModal extends StatelessWidget {
  final String gifAsset;
  final String text;
  final List<AppModalAction> actions;
  final EdgeInsetsGeometry contentPadding;
  final BorderRadiusGeometry borderRadius;

  const AppModal({
    super.key,
    required this.gifAsset,
    required this.text,
    this.actions = const [],
    this.contentPadding = const EdgeInsets.fromLTRB(24, 28, 24, 20),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  }) : assert(actions.length <= 2, 'Modal supports at most two actions');

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTypography.body.copyWith(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.blueGray374957,
      height: 1.25,
      letterSpacing: 0.15,
      decoration: TextDecoration.none, 
    );

    final maxWidth = 92.w;
    final cardWidth = maxWidth.clamp(280.0, 360.0);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: cardWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: contentPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(gifAsset, fit: BoxFit.contain, height: 90),
              SizedBox(height: 2.5.h),
              DefaultTextStyle(
                style: textStyle,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
              ),
              SizedBox(height: 2.5.h),

              if (actions.isNotEmpty) _buildActionsRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionsRow(BuildContext context) {
    final buttons = actions
        .map(
          (a) => CustomButton.capsule(
            label: a.label,
            onPressed: a.onPressed,
            filled: a.filled,
            fillColor: a.fillColor,
            borderColor: a.borderColor,
            textColor: a.textColor,
            trailingSvgAsset: a.trailingSvgAsset,
            width: 120,
            height: 44,
          ),
        )
        .toList(growable: false);

    if (buttons.length == 1) {
      return Center(child: buttons.first);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [buttons[0], const SizedBox(width: 12), buttons[1]],
    );
  }
}

/// Helper to show the modal as a dialog.
Future<T?> showAppModal<T>({
  required BuildContext context,
  required String gifAsset,
  required String text,
  List<AppModalAction> actions = const [],
  bool barrierDismissible = false,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (ctx) => Material(
      type: MaterialType.transparency,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppModal(gifAsset: gifAsset, text: text, actions: actions),
        ),
      ),
    ),
  );
}