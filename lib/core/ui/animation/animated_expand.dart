// import 'package:flutter/material.dart';

// class AnimatedExpand extends StatefulWidget {
//   final Widget child;
//   final bool expand;
//   final Duration? duration;

//   const AnimatedExpand({Key? key, required this.child, this.duration, this.expand = false}) : super(key: key);

//   @override
//   State<AnimatedExpand> createState() => _AnimatedExpandState();
// }

// class _AnimatedExpandState extends State<AnimatedExpand> with SingleTickerProviderStateMixin {
//   late final AnimationController expandController;
//   late final Animation<double> animation;

//   late final bool initialState = widget.expand;
//   late final Duration duration;

//   @override
//   void initState() {
//     super.initState();
//     prepareAnimations();
//     if (widget.expand) {
//       expandController.forward();
//     }
//   }

//   void prepareAnimations() {
//     duration = widget.duration ?? const Duration(milliseconds: 400);
//     expandController = AnimationController(vsync: this, duration: duration)
//       ..addListener(() {
//         setState(() {});
//       });
//     final Animation<double> curve = CurvedAnimation(
//       parent: expandController,
//       curve: Curves.ease,
//     );
//     animation = Tween(
//       begin: initialState ? 1.0 : 0.0,
//       end: 1.0,
//     ).animate(curve);
//   }

//   @override
//   void didUpdateWidget(AnimatedExpand oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.expand) {
//       expandController.forward();
//     } else {
//       expandController.reverse();
//     }
//   }

//   @override
//   void dispose() {
//     expandController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizeTransition(
//       axisAlignment: 1.0,
//       sizeFactor: animation,
//       child: widget.child,
//     );
//   }
// }
