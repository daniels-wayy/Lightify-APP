part of 'package:lightify/pages/main/home/ui/widget/device_card.dart';

class _EffectIcon extends AnimatedWidget {
  const _EffectIcon(Animation<double> animation, this.color, {Key? key})
      : super(
          key: key,
          listenable: animation,
        );

  final Color color;

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    final scale = 0.05 * value;

    return Transform.scale(
      scale: 1.0 + scale,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppConstants.widget.defaultBorderRadius,
          boxShadow: [
            BoxShadow(
              color: Color.lerp(color, AppColors.white, 0.33)!.withOpacity(0.6),
              blurRadius: 3.0,
              offset: Offset.zero,
            ),
          ],
        ),
      ),
    );
  }
}
