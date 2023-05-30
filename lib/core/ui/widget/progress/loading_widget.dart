import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';

class LoadingWidget extends StatefulWidget {
  final double? size;
  final Color? color;
  final double? thickness;
  final bool animate;
  final double? rotationAnimationValue;

  const LoadingWidget({
    Key? key,
    this.size,
    this.color = AppColors.gray500,
    this.thickness,
    this.animate = true,
    this.rotationAnimationValue,
  }) : super(key: key);

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LoadingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }

    if (widget.rotationAnimationValue != null && widget.rotationAnimationValue != oldWidget.rotationAnimationValue) {
      _controller.animateTo(widget.rotationAnimationValue!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: child,
        );
      },
      child: Image.asset(
        'assets/images/loader.png',
        width: width(16),
        height: height(16),
        color: widget.color,
      ),
    );
  }
}
