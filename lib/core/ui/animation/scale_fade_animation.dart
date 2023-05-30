import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';

class ScaleFadeAnimation extends StatefulWidget {
  const ScaleFadeAnimation({super.key, required this.child});

  final Widget child;

  @override
  State<ScaleFadeAnimation> createState() => ScaleFadeAnimationState();
}

class ScaleFadeAnimationState extends State<ScaleFadeAnimation> {
  final tween = MovieTween();

  @override
  void initState() {
    super.initState();
    tween
        .scene(duration: const Duration(milliseconds: 400))
        .tween('opacity', Tween<double>(begin: 0.0, end: 1.0), curve: Curves.ease)
        .tween('scale', Tween<double>(begin: 0.8, end: 1.0), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder<Movie>(
      duration: tween.duration,
      curve: tween.curve,
      tween: tween,
      builder: (_, value, child) {
        return Opacity(
          opacity: value.get('opacity'),
          child: Transform.scale(
            scale: value.get('scale'),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
