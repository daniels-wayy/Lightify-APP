part of 'package:lightify/pages/device_details/ui/device_details_page.dart';

class _DetailsDeviceCardWidget extends StatelessWidget {
  const _DetailsDeviceCardWidget({
    required this.device,
    required this.onPowerChanged,
    required this.onBrightnessChanged,
  });

  final Device device;
  final void Function(bool) onPowerChanged;
  final void Function(int) onBrightnessChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width(18)),
      child: SizedBox(
        height: height(48),
        width: double.maxFinite,
        child: DeviceCard(
          device: device,
          heroTag: device.deviceInfo.topic,
          onPowerChanged: onPowerChanged,
          onBrightnessChanged: onBrightnessChanged,
          mainAxisAlignment: MainAxisAlignment.center,
          brightnessIconSize: 24,
          brightnessTextSize: 15,
          hideDetailsButton: true,
          hideDeviceName: true,
          scaleFactor: 1.05,
        ),
      ),
    );
  }
}
