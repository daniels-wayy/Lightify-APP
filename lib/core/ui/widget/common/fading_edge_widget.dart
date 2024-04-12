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
    this.stops,
  });

  final Widget child;
  final Axis scrollDirection;
  final List<double>? stops;

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
          stops: stops ?? const [0.0, 0.06, 0.96, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: child,
    );
  }
}
