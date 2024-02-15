import 'package:flutter/material.dart';
import 'package:lightify/core/ui/utils/vibration_util.dart';

class BouncingWidget extends StatefulWidget {
  final Widget child;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final double? minScale;
  final bool bounceOnTap;

  const BouncingWidget({
    Key? key,
    this.onTap,
    this.onLongTap,
    this.minScale,
    required this.child,
    this.bounceOnTap = false,
  }) : super(key: key);

  static const _DURATION = Duration(milliseconds: 125);

  @override
  _BouncingWidgetState createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<BouncingWidget> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: BouncingWidget._DURATION, reverseDuration: BouncingWidget._DURATION)
          ..addListener(() => setState(() {}));
    _animation = Tween<double>(begin: 1.0, end: widget.minScale ?? 0.85)
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.easeOutSine));
  }

  @override
  void dispose() {
    _controller!.dispose();

    super.dispose();
  }

  Widget _childWidget() => Transform.scale(
        scale: _animation?.value ?? 1.0,
        child: widget.child,
      );

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: widget.onTap == null
            ? null
            : () {
                widget.onTap!();
                if (widget.bounceOnTap) {
                  _controller?.forward().then((_) => _controller?.reverse());
                }
              },
        onTapDown: (_) => _controller?.forward(),
        onTapUp: (_) => _controller?.reverse(),
        onTapCancel: () => _controller?.reverse(),
        onLongPress: widget.onLongTap == null
            ? null
            : () {
                VibrationUtil.vibrate();
                widget.onLongTap?.call();
              },
        behavior: HitTestBehavior.translucent,
        child: _childWidget(),
      );
}
