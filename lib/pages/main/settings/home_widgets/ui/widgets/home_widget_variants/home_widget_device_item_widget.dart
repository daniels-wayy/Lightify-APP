import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lightify/core/ui/animation/scale_fade_animation.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/pages/main/settings/home_widgets/data/models/home_widget_device_entity.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/home_widget_variants/home_widget_variant.dart';

class HomeWidgetDeviceItem extends StatelessWidget {
  const HomeWidgetDeviceItem({
    super.key,
    required this.deviceEntity,
    this.variant = HomeWidgetVariant.smallest,
    this.addBrightness = false,
  });

  final HomeWidgetDeviceEntity deviceEntity;
  final HomeWidgetVariant variant;
  final bool addBrightness;

  @override
  Widget build(BuildContext context) {
    final iconSize = variant.iconSize;
    return ScaleFadeAnimation(
      child: Padding(
        padding: EdgeInsets.all(addBrightness ? 3.0 : 0.0),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              painter: _ProgressPainter(
                deviceEntity.currentBrightness,
                deviceEntity.color,
                variant,
              ),
              child: Center(
                child: Icon(deviceEntity.icon, color: Colors.white70, size: iconSize),
              ),
            ),
            if (addBrightness)
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: -30.0,
              child: Center(
                child: Text(
                  '${deviceEntity.brightnessPercent}%',
                  style: context.textTheme.titleSmall?.copyWith(
                    letterSpacing: 0.2,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(deviceEntity.currentPowerState ? 0.9 : 0.45),
                    fontSize: 19,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final HomeWidgetVariant variant;

  const _ProgressPainter(this.progress, this.color, this.variant);

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = variant.progressValueStroke;
    final Paint trackPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = (size.width - strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, trackPaint);

    final progressAngle = 2 * pi * progress;
    const progressStartAngle = -pi / 2;
    final Rect progressRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(progressRect, progressStartAngle, progressAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
