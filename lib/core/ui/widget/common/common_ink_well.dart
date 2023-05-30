import 'dart:io';
import 'package:flutter/material.dart';

class CommonInkWell extends StatelessWidget {
  final Color color;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final bool showHover;
  final Widget child;

  const CommonInkWell({
    super.key,
    this.color = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.zero),
    this.onTap,
    this.showHover = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        splashColor: Platform.isIOS
            ? Colors.transparent
            : showHover
                ? null
                : Colors.transparent, // hide material ripple effect for iOS, and for Android while enableHover is false
        highlightColor: showHover ? null : Colors.transparent,
        focusColor: Colors.transparent,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
