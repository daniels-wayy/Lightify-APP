part of 'package:lightify/pages/device_details/ui/device_details_page.dart';

class _DetailsColorPickerWidget extends StatefulWidget {
  const _DetailsColorPickerWidget({
    required this.device,
    required this.onColorChanged,
    required this.onCustomColorTap,
  });

  final Device device;
  final void Function(HSVColor)? onColorChanged;
  final void Function()? onCustomColorTap;

  @override
  State<_DetailsColorPickerWidget> createState() => _DetailsColorPickerWidgetState();
}

class _DetailsColorPickerWidgetState extends State<_DetailsColorPickerWidget> {
  late final ValueNotifier<Color> colorValue;

  @override
  void initState() {
    super.initState();
    colorValue = ValueNotifier(widget.device.getColor);
  }

  @override
  void didUpdateWidget(covariant _DetailsColorPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.device.color != widget.device.color) {
      colorValue.value = widget.device.getColor;
    }
  }

  @override
  void dispose() {
    super.dispose();
    colorValue.dispose();
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
              Text(AppConstants.strings.COLOR_PICKER, style: context.textTheme.titleMedium),
              BouncingWidget(
                onTap: widget.onCustomColorTap,
                child: Icon(Icons.edit_outlined, color: AppColors.gray200, size: height(20)),
              ),
            ],
          ),
          SizedBox(height: height(10)),
          ValueListenableBuilder<Color>(
            valueListenable: colorValue,
            builder: (_, value, __) => ColorPicker(
              portraitOnly: true,
              pickerAreaHeightPercent: 0.5,
              colorPickerWidth: ScreenUtil.screenWidthLp,
              paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: AppConstants.widget.smallBorderRadius,
              labelTypes: const [],
              displayThumbColor: true,
              pickerHsvColor: HSVColor.fromColor(value),
              pickerColor: value,
              onColorChanged: (val) => colorValue.value = val,
              onHsvColorChanged: widget.onColorChanged,
              enableAlpha: false,
            ),
          ),
        ],
      ),
    );
  }
}
