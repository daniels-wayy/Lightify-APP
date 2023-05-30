// import 'package:flutter/material.dart';
// import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
// import 'package:simple_animations/movie_tween/movie_tween.dart';

// class SlideFadeAnimation extends StatefulWidget {
//   const SlideFadeAnimation({
//     super.key,
//     required this.child,
//     this.control = Control.play,
//   });

//   final Widget child;
//   final Control control;

//   @override
//   State<SlideFadeAnimation> createState() => _SlideFadeAnimationState();
// }

// class _SlideFadeAnimationState extends State<SlideFadeAnimation> {
//   final tween = MovieTween();

//   @override
//   void initState() {
//     super.initState();
//     tween
//         .scene(duration: const Duration(milliseconds: 500))
//         .tween('opacity', Tween<double>(begin: 0.0, end: 1.0), curve: Curves.easeInCirc)
//         .tween('offset', Tween<Offset>(begin: const Offset(0.0, 40.0), end: Offset.zero), curve: Curves.easeIn);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomAnimationBuilder<Movie>(
//       tween: tween,
//       control: Control.play,
//       curve: tween.curve,
//       duration: tween.duration,
//       builder: (_, value, child) {
//         return Opacity(
//           opacity: value.get('opacity'),
//           child: Transform.translate(
//             offset: value.get('offset'),
//             child: child,
//           ),
//         );
//       },
//       child: widget.child,
//     );
//   }
// }
