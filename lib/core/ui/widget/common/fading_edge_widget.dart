import 'package:flutter/material.dart';

extension _AxisX on Axis {
  Alignment get alignmentBegin => this == Axis.horizontal ? Alignment.centerLeft : Alignment.topCenter;
  Alignment get alignmentEnd => this == Axis.horizontal ? Alignment.centerRight : Alignment.bottomCenter;
}

class FadingEdge extends StatelessWidget {
  const FadingEdge({
    super.key,
    required this.child,
    required this.scrollDirection,
  });

  final Widget child;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: scrollDirection.alignmentBegin,
          end: scrollDirection.alignmentEnd,
          colors: const [
            Colors.black,
            Colors.transparent,
            Colors.transparent,
            Colors.black,
          ],
          stops: const [0.0, 0.05, 0.93, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: child,
    );
  }
}
