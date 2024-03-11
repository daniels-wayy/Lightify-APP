// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lightify/core/ui/utils/vibration_util.dart';

class CustomHoldDetector extends StatefulWidget {
  const CustomHoldDetector({
    super.key,
    required this.child,
    required this.onLongPressDrag,
    this.endScale = 1.08,
    this.onTap,
    this.bounceOnTap = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final void Function(double) onLongPressDrag;
  final double endScale;
  final bool bounceOnTap;

  static const _DURATION = Duration(milliseconds: 200);
  static const _REVERSE_DURATION = Duration(milliseconds: 300);

  @override
  State<CustomHoldDetector> createState() => _CustomHoldDetectorState();
}

class _CustomHoldDetectorState extends State<CustomHoldDetector> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: CustomHoldDetector._DURATION,
      reverseDuration: CustomHoldDetector._REVERSE_DURATION,
    );
    animation = Tween<double>(begin: 1.0, end: widget.endScale)
        .animate(CurvedAnimation(parent: controller, curve: Curves.ease));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, x) {
        return GestureDetector(
          onTap: widget.onTap == null
              ? null
              : () {
                  widget.onTap!();
                  VibrationUtil.vibrate();
                  if (widget.bounceOnTap) {
                    controller.forward().then((_) => controller.reverse());
                  }
                },
          onTapDown: (_) => controller.forward(),
          onTapUp: (_) => controller.reverse(),
          onLongPress: () => VibrationUtil.vibrate(),
          onLongPressEnd: (_) => controller.reverse(),
          onLongPressCancel: () => controller.reverse(),
          onLongPressMoveUpdate: (d) {
            final width = x.maxWidth;
            final dragFactor = d.localPosition.dx / width;
            widget.onLongPressDrag(dragFactor);
          },
          behavior: HitTestBehavior.translucent,
          child: AnimatedBuilder(
            animation: controller,
            builder: (_, child) => Transform.scale(scale: animation.value, child: child),
            child: widget.child,
          ),
        );
      },
    );
  }
}
