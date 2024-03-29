import 'package:flutter/material.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';

class CustomPageRoutes {
  static PageRoute<T> fadablePageRoute<T>({
    required Widget child,
    RouteSettings? settings,
    double? backgroundOpacity,
  }) =>
      PageRouteBuilder<T>(
        opaque: false,
        settings: settings,
        pageBuilder: (_, __, ___) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final transitionOffsetTween = Tween<double>(begin: 0.0, end: 1.0);
          final fadeAnimation = transitionOffsetTween.animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInSine),
          );
          return FadeTransition(opacity: fadeAnimation, child: child);
        },
        barrierColor: AppColors.fullBlack.withOpacity(backgroundOpacity ?? 0.1),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionDuration: const Duration(milliseconds: 300),
      );

  // static PageRoute<T> modalSheetPageRoute<T>({required Widget child, RouteSettings? settings}) => PageRouteBuilder<T>(
  //       opaque: false,
  //       settings: settings,
  //       pageBuilder: (_, __, ___) => child,
  //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //         final transitionOffsetTween = Tween<Offset>(
  //           begin: const Offset(0.0, 1.0),
  //           end: Offset.zero,
  //         );
  //         final offsetAnimation = transitionOffsetTween.animate(
  //           CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
  //         );
  //         return SlideTransition(position: offsetAnimation, child: child);
  //       },
  //       barrierColor: AppColors.fullBlack.withOpacity(0.45),
  //       reverseTransitionDuration: const Duration(milliseconds: 300),
  //       transitionDuration: const Duration(milliseconds: 300),
  //     );
}

class CrossFadeScalePageRoute<T> extends MaterialPageRoute<T> {
  CrossFadeScalePageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 220);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: animation, curve: const Interval(0.0, 1.0, curve: Curves.ease)),
    );

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: animation, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );
    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }
}
