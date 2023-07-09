import 'package:flutter/material.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/helpers/custom_hold_detector.dart';

class CommonSlider extends StatefulWidget {
  const CommonSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  final double value;
  final void Function(double) onChanged;
  final IconData icon;

  @override
  State<CommonSlider> createState() => _CommonSliderState();
}

class _CommonSliderState extends State<CommonSlider> {
  late final ValueNotifier<double> state;
  var prevState = -1.0;

  @override
  void initState() {
    state = ValueNotifier(widget.value);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CommonSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      state.value = widget.value;
    }
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(44),
      width: double.maxFinite,
      child: CustomHoldDetector(
        endScale: 1.04,
        onLongPressDrag: _onBreathChange,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            height(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.fullBlack,
              borderRadius: AppConstants.widget.mediumBorderRadius,
              border: Border.all(color: AppColors.gray100),
            ),
            child: Stack(
              children: [
                LayoutBuilder(builder: (_, c) {
                  final width = c.maxWidth;
                  return ValueListenableBuilder(
                    valueListenable: state,
                    builder: (_, value, __) {
                      if (value.isInfinite) {
                        return const SizedBox.shrink();
                      }
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 60),
                        height: double.maxFinite,
                        width: width * value,
                        color: AppColors.gray100,
                      );
                    },
                  );
                }),
                Positioned.fill(
                  child: Row(
                    children: [
                      SizedBox(width: width(12)),
                      Icon(widget.icon, size: width(24), color: AppColors.white60),
                      SizedBox(width: width(6)),
                      ValueListenableBuilder(
                          valueListenable: state,
                          builder: (context, value, _) {
                            if (value.isInfinite) {
                              return const SizedBox.shrink();
                            }
                            final breathPercentage = (value * 100).toInt();
                            return Text('$breathPercentage%',
                                style: context.textTheme.displaySmall!.copyWith(
                                  color: AppColors.white.withOpacity(0.6),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.45,
                                  fontSize: height(15),
                                ));
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onBreathChange(double value) {
    if (prevState != value) {
      prevState = value;
      value = value <= 0.01
          ? 0.00
          : value >= 0.99
              ? 1.0
              : value;
      if (value >= 0.0 && value <= 1.0) {
        state.value = value;
        widget.onChanged(value.toPrecision(3));
      }
    }
  }
}
