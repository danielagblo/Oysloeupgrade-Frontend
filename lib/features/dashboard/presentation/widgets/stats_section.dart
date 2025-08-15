import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';

class StatsSection extends StatefulWidget {
  const StatsSection({super.key});

  @override
  State<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;

  static const _items = <_StatItem>[
    _StatItem(label: 'Electronics', valueText: '45k+', progress: 0.78),
    _StatItem(label: 'Vehicle', valueText: '200+', progress: 0.42),
    _StatItem(label: 'Furniture', valueText: '158+', progress: 0.66),
    _StatItem(label: 'Sporting', valueText: '100+', progress: 0.85),
    _StatItem(label: 'Fashion', valueText: '35+', progress: 0.28),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            const count = 5;
            final spacing = 2.8.w;
            final avail = constraints.maxWidth;
            final size = math.min(
              12.5.h,
              (avail - spacing * (count - 1)) / count,
            );

            final children = <Widget>[];
            for (var i = 0; i < _items.length; i++) {
              final it = _items[i];
              children.add(
                _StatCircle(
                  label: it.label,
                  valueText: it.valueText,
                  progress: it.progress * _anim.value,
                  size: size,
                ),
              );
              if (i != _items.length - 1) {
                children.add(SizedBox(width: spacing));
              }
            }

            return SizedBox(
              height: size,
              child: Row(children: children),
            );
          },
        );
      },
    );
  }
}

class _StatItem {
  final String label;
  final String valueText;
  final double progress;
  const _StatItem({
    required this.label,
    required this.valueText,
    required this.progress,
  });
}

class _StatCircle extends StatelessWidget {
  const _StatCircle({
    required this.label,
    required this.valueText,
    required this.progress,
    required this.size,
  });

  final String label;
  final String valueText;
  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    final double stroke = math.max(6, size * 0.065);
    final colors = Theme.of(context);

    return SizedBox(
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _RingArcPainter(
              progress: progress.clamp(0.0, 1.0),
              strokeWidth: stroke,
              trackColor: AppColors.grayD9.withValues(alpha: 0.55),
              progressColor: AppColors.blueGray374957,
              dotColor: AppColors.blueGray374957,
              startAngle: -math.pi * 0.5,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.labelSmall.copyWith(
                  color: colors.colorScheme.onSurface.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.3.h),
              Text(
                valueText,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  color: AppColors.blueGray374957,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingArcPainter extends CustomPainter {
  _RingArcPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
    required this.dotColor,
    this.startAngle = -math.pi / 2,
  });

  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;
  final Color dotColor;
  final double startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, track);

    if (progress > 0) {
      final sweep = (math.pi * 2) * progress;
      final prog = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweep, false, prog);

      final endAngle = startAngle + sweep;
      final endDx = center.dx + radius * math.cos(endAngle);
      final endDy = center.dy + radius * math.sin(endAngle);
      final dotPaint = Paint()..color = dotColor;
      canvas.drawCircle(Offset(endDx, endDy), strokeWidth * 0.22, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.startAngle != startAngle;
  }
}
