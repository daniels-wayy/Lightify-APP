part of 'package:lightify/pages/device_details/ui/device_details_page.dart';

class _DetailsPresetColorsWidget extends StatelessWidget {
  const _DetailsPresetColorsWidget({
    this.onPresetTap,
    this.onColorPresetAdd,
    this.onColorPresetRemove,
  });

  final void Function(HSVColor)? onPresetTap;
  final void Function()? onColorPresetAdd;
  final void Function(ColorPreset)? onColorPresetRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width(18)),
          child: Text(AppConstants.strings.COLOR_PRESETS, style: context.textTheme.titleMedium),
        ),
        SizedBox(height: height(10)),
        SizedBox(
          height: height(70),
          width: double.maxFinite,
          child: BlocBuilder<UserPrefCubit, UserPrefState>(builder: (_, state) {
            final displayPresets = state.getDisplayColorPresets;
            return FadingEdge(
              scrollDirection: Axis.horizontal,
              child: ListView.separated(
                controller: ScrollController(),
                scrollDirection: Axis.horizontal,
                itemCount: displayPresets.length + 1,
                padding: EdgeInsets.symmetric(horizontal: width(18)),
                separatorBuilder: (_, __) => SizedBox(width: width(18)),
                itemBuilder: (_, index) {
                  if (index == displayPresets.length) return _buildAddPresetButton(context);
                  return _buildColorBubble(context, displayPresets[index]);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAddPresetButton(BuildContext context) {
    return ScaleFadeAnimation(
      child: BouncingWidget(
        onTap: onColorPresetAdd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: height(50),
              height: height(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gray200, width: 1.5),
              ),
              child: Center(child: Icon(Icons.add, color: AppColors.gray200, size: height(26))),
            ),
            SizedBox(height: height(8)),
            Text(
              AppConstants.strings.ADD,
              style: context.textTheme.displaySmall?.copyWith(
                color: AppColors.gray200,
                fontSize: height(10),
                letterSpacing: -0.1,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildColorBubble(BuildContext context, ColorPreset preset) {
    return ScaleFadeAnimation(
      child: BouncingWidget(
        onLongTap: !preset.isDefault ? () => onColorPresetRemove?.call(preset) : null,
        onTap: () => onPresetTap?.call(preset.color),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: height(50),
              height: height(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: preset.getRawColor.withOpacity(0.9),
                border: Border.all(color: AppColors.gray200, width: 1.0),
              ),
            ),
            SizedBox(height: height(8)),
            Text(
              preset.colorName,
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade300.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
