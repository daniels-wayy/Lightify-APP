import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final Duration delay;
  final Duration duration;
  final Widget child;

  const FadeAnimation({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder<double>(
      delay: delay,
      duration: duration,
      curve: Curves.ease,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: child,
    );
  }
}
