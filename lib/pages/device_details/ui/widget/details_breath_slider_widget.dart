part of 'package:lightify/pages/device_details/ui/device_details_page.dart';

class _DetailsBreathSliderWidget extends StatelessWidget {
  const _DetailsBreathSliderWidget({required this.device, required this.onBreathChanged});

  final Device device;
  final void Function(double)? onBreathChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppConstants.strings.COLOR_BREATH, style: context.textTheme.titleMedium),
          SizedBox(height: height(10)),
          SizedBox(
            height: height(44),
            width: double.maxFinite,
            child: CommonSlider(
              icon: Icons.adjust,
              onChanged: (value) => onBreathChanged?.call(value),
              value: device.breathFactor,
            ),
          ),
        ],
      ),
    );
  }
}
