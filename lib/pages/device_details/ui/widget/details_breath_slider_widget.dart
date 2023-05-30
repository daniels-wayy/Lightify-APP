part of 'package:lightify/pages/device_details/ui/device_details_page.dart';

class _DetailsBreathSliderWidget extends StatefulWidget {
  const _DetailsBreathSliderWidget({required this.device, required this.onBreathChanged});

  final Device device;
  final void Function(double)? onBreathChanged;

  @override
  State<_DetailsBreathSliderWidget> createState() => __DetailsBreathSliderWidgetState();
}

class __DetailsBreathSliderWidgetState extends State<_DetailsBreathSliderWidget> {
  late final ValueNotifier<double> breathState;
  var prevBreathState = -1.0;

  @override
  void initState() {
    breathState = ValueNotifier(widget.device.breathFactor);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _DetailsBreathSliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.device.breathFactor != widget.device.breathFactor) {
      breathState.value = widget.device.breathFactor;
    }
  }

  @override
  void dispose() {
    breathState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppConstants.strings.COLOR_BREATH, style: context.textTheme.titleMedium),
              ValueListenableBuilder(
                  valueListenable: breathState,
                  builder: (_, value, __) {
                    if (value.isInfinite) {
                      return const SizedBox.shrink();
                    }
                    return AnimatedOpacity(
                      opacity: value > 0.0 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 400),
                      child: BouncingWidget(
                        onTap: () => _onBreathChange(0.0),
                        child: Icon(Icons.restart_alt_rounded, color: AppColors.gray200, size: height(20)),
                      ),
                    );
                  }),
            ],
          ),
          SizedBox(height: height(10)),
          SizedBox(
            height: height(44),
            width: double.maxFinite,
            child: CustomHoldDetector(
              endScale: 1.04,
              onLongPressDrag: _onBreathChange,
              child: ClipRRect(
                borderRadius: AppConstants.widget.mediumBorderRadius,
                child: ColoredBox(
                  color: AppColors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.gray200,
                      borderRadius: AppConstants.widget.mediumBorderRadius,
                      gradient: LinearGradient(
                        colors: [AppColors.gray200, AppColors.gray200.withOpacity(0.8)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        LayoutBuilder(builder: (_, c) {
                          final width = c.maxWidth;
                          return ValueListenableBuilder(
                            valueListenable: breathState,
                            builder: (_, value, __) {
                              if (value.isInfinite) {
                                return const SizedBox.shrink();
                              }
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 60),
                                height: double.maxFinite,
                                width: width * value,
                                color: AppColors.white.withOpacity(0.3),
                              );
                            },
                          );
                        }),
                        Positioned.fill(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: width(12)),
                              Icon(Icons.adjust, size: width(24), color: AppColors.white),
                              SizedBox(width: width(6)),
                              ValueListenableBuilder(
                                  valueListenable: breathState,
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
            ),
          ),
        ],
      ),
    );
  }

  void _onBreathChange(double value) {
    if (prevBreathState != value) {
      prevBreathState = value;
      value = value <= 0.01
          ? 0.00
          : value >= 0.99
              ? 1.0
              : value;
      if (value >= 0.0 && value <= 1.0) {
        breathState.value = value;
        final formattedBreathState = value.toPrecision(3);
        widget.onBreathChanged?.call(formattedBreathState);
      }
    }
  }
}
