part of 'package:lightify/pages/device_details/ui/device_details_page.dart';

class _DetailsEffectsControlsWidget extends StatefulWidget {
  const _DetailsEffectsControlsWidget({
    required this.device,
    required this.onEffectChanged,
    required this.onEffectSpeedChanged,
    required this.onEffectScaleChanged,
  });

  final Device device;
  final void Function(int) onEffectChanged;
  final void Function(double) onEffectSpeedChanged;
  final void Function(double) onEffectScaleChanged;

  @override
  State<_DetailsEffectsControlsWidget> createState() => _DetailsEffectsControlsWidgetState();
}

class _DetailsEffectsControlsWidgetState extends State<_DetailsEffectsControlsWidget> {
  @override
  void didUpdateWidget(covariant _DetailsEffectsControlsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.device.effectId != widget.device.effectId) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width(18)),
          child: Text(AppConstants.strings.EFFECTS, style: context.textTheme.titleMedium),
        ),
        SizedBox(height: height(10)),
        SizedBox(
          height: height(48),
          width: double.maxFinite,
          child: FadingEdge(
            scrollDirection: Axis.horizontal,
            child: ListView.separated(
              controller: ScrollController(),
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.settings.effects.length,
              padding: EdgeInsets.symmetric(horizontal: width(18)),
              separatorBuilder: (_, __) => SizedBox(width: width(18)),
              itemBuilder: (_, index) {
                final effect = AppConstants.settings.effects[index];
                return _buildEffectBubble(context, effect);
              },
            ),
          ),
        ),
        AnimatedCrossFade(
          sizeCurve: Curves.ease,
          crossFadeState: widget.device.effectRunning ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
          firstChild: Column(
            children: [
              SizedBox(height: height(20)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(18)),
                child: SizedBox(
                  height: height(44),
                  width: double.maxFinite,
                  child: CommonSlider(
                    icon: Icons.speed,
                    onChanged: _onEffectSpeedChanged,
                    value: getSpeedValue(),
                  ),
                ),
              ),
              SizedBox(height: height(18)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(18)),
                child: SizedBox(
                  height: height(44),
                  width: double.maxFinite,
                  child: CommonSlider(
                    icon: Icons.photo_size_select_large,
                    onChanged: _onEffectScaleChanged,
                    value: getScaleValue(),
                  ),
                ),
              ),
              SizedBox(height: height(18)),
            ],
          ),
          secondChild: Container(),
        ),
      ],
    );
  }

  Widget _buildEffectBubble(BuildContext context, EffectEntity effectEntity) {
    final isSelected = effectEntity.id == widget.device.effectId;
    return BouncingWidget(
      onTap: () => widget.onEffectChanged(effectEntity.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: !isSelected ? null : effectEntity.previewColor,
          borderRadius: BorderRadius.circular(
            height(12),
          ),
          border: isSelected ? null : Border.all(color: AppColors.gray100),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(24)),
          child: Center(
            child: Text(
              effectEntity.name,
              style: context.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  double getSpeedValue() {
    final value = !widget.device.effectRunning
        ? 0.0
        : FunctionUtil.mapValue(
            widget.device.effectSpeed.toDouble(),
            AppConstants.api.EFFECT_MIN_SPEED.toDouble(),
            AppConstants.api.EFFECT_MAX_SPEED.toDouble(),
          );
    return value < 0.0 ? 0.0 : value;
  }

  double getScaleValue() {
    final value = !widget.device.effectRunning
        ? 0.0
        : FunctionUtil.mapValue(
            widget.device.effectScale.toDouble(),
            AppConstants.api.EFFECT_MIN_SCALE.toDouble(),
            AppConstants.api.EFFECT_MAX_SCALE.toDouble(),
          );
    return value < 0.0 ? 0.0 : value;
  }

  void _onEffectSpeedChanged(double value) {
    final mappedValue = FunctionUtil.reverseMapValue(
        value, AppConstants.api.EFFECT_MIN_SPEED.toDouble(), AppConstants.api.EFFECT_MAX_SPEED.toDouble());
    widget.onEffectSpeedChanged(mappedValue);
  }

  void _onEffectScaleChanged(double value) {
    final mappedValue = FunctionUtil.reverseMapValue(
        value, AppConstants.api.EFFECT_MIN_SCALE.toDouble(), AppConstants.api.EFFECT_MAX_SCALE.toDouble());
    widget.onEffectScaleChanged(mappedValue);
  }
}
