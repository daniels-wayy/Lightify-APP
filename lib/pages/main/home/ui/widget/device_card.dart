// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/routes/root_routes.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/pages/device_details/domain/model/device_details_page_args.dart';
import 'package:lightify/core/ui/widget/helpers/custom_hold_detector.dart';

part 'package:lightify/pages/main/home/ui/widget/effect_icon.dart';

class DeviceCard extends StatefulWidget {
  final Device device;
  final void Function(bool) onPowerChanged;
  final void Function(int) onBrightnessChanged;
  final void Function(HSVColor)? onColorChanged;
  final void Function(double)? onBreathChanged;
  final void Function(int)? onEffectChanged;
  final void Function(double)? onEffectSpeedChanged;
  final void Function(double)? onEffectScaleChanged;
  final bool hideDetailsButton;
  final bool hideDeviceName;
  final MainAxisAlignment mainAxisAlignment;
  final int brightnessIconSize;
  final int brightnessTextSize;
  final double scaleFactor;
  final bool showEffectIndication;
  // final String heroTag;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onPowerChanged,
    required this.onBrightnessChanged,
    this.onEffectChanged,
    this.onEffectSpeedChanged,
    this.onEffectScaleChanged,
    this.onColorChanged,
    this.onBreathChanged,
    // required this.heroTag,
    this.hideDetailsButton = false,
    this.hideDeviceName = false,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.brightnessIconSize = 26,
    this.brightnessTextSize = 12,
    this.scaleFactor = 1.08,
    this.showEffectIndication = true,
  });

  static const COLORS_SWITCH_DURATION = Duration(milliseconds: 250);

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> with SingleTickerProviderStateMixin {
  late final AnimationController effectController;

  var brightnessState = ValueNotifier<double>(0.0);
  var prevBrightnessState = -999.0;
  var powerState = false;

  @override
  void initState() {
    super.initState();
    _onPowerStateSet(isInit: true);
    _onBrightnessStateSet(isInit: true);
    _prepareEffectControllers();
  }

  void _prepareEffectControllers() {
    effectController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    if (widget.device.effectRunning) {
      effectController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant DeviceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onPowerStateSet();
    _onBrightnessStateSet();

    if (!widget.showEffectIndication) {
      return;
    }

    if (!oldWidget.device.effectRunning && widget.device.effectRunning) {
      effectController.repeat(reverse: true);
    } else if (oldWidget.device.effectRunning && !widget.device.effectRunning) {
      effectController.stop();
    }
  }

  @override
  void dispose() {
    brightnessState.dispose();
    effectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = powerState ? Icons.light_mode_sharp : Icons.light_mode_outlined;
    final color = widget.device.getCardColor;
    final isBrightRange = widget.device.inBrightRange /*false*/;
    final dataColor = isBrightRange ? AppColors.fullBlack.withOpacity(0.9) : AppColors.white;
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: widget.device.effectRunning && widget.device.powered && widget.showEffectIndication
                ? _EffectIcon(effectController, color)
                : Container(),
          ),
        ),
        CustomHoldDetector(
          onTap: _onPowerChange,
          onLongPressDrag: _onBrightnessChange,
          endScale: widget.scaleFactor,
          child: ClipRRect(
            borderRadius: AppConstants.widget.defaultBorderRadius,
            child: ColoredBox(
              color: AppColors.white,
              child: AnimatedContainer(
                duration: DeviceCard.COLORS_SWITCH_DURATION,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppConstants.widget.defaultBorderRadius,
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    LayoutBuilder(builder: (_, c) {
                      final width = c.maxWidth;
                      return ValueListenableBuilder(
                        valueListenable: brightnessState,
                        builder: (_, value, __) {
                          if (value.isInfinite) {
                            return const SizedBox.shrink();
                          }
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 60),
                            height: double.maxFinite,
                            width: width * value,
                            color: isBrightRange ? AppColors.black.withOpacity(0.15) : AppColors.white.withOpacity(0.3),
                          );
                        },
                      );
                    }),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(12), vertical: height(12)),
                      child: Column(
                        mainAxisAlignment: widget.mainAxisAlignment,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(icon, size: width(widget.brightnessIconSize), color: dataColor),
                              SizedBox(width: width(6)),
                              ValueListenableBuilder(
                                  valueListenable: brightnessState,
                                  builder: (context, value, _) {
                                    if (value.isInfinite) {
                                      return const SizedBox.shrink();
                                    }
                                    final brightnessPercentage = (value * 100).toInt();
                                    return AnimatedDefaultTextStyle(
                                      style: context.textTheme.displaySmall?.copyWith(
                                            color: isBrightRange
                                                ? AppColors.black.withOpacity(0.6)
                                                : AppColors.white.withOpacity(0.6),
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -0.45,
                                            fontSize: height(widget.brightnessTextSize),
                                          ) ??
                                          const TextStyle(),
                                      duration: DeviceCard.COLORS_SWITCH_DURATION,
                                      child: Text('$brightnessPercentage%'),
                                    );
                                  }),
                              const Spacer(),
                              if (!widget.hideDetailsButton)
                                BouncingWidget(
                                  onTap: _onDetailsTap,
                                  child: AnimatedContainer(
                                    width: width(26),
                                    height: width(26),
                                    duration: DeviceCard.COLORS_SWITCH_DURATION,
                                    decoration: BoxDecoration(color: dataColor, shape: BoxShape.circle),
                                    child: Center(child: Icon(Icons.more_horiz, color: color)),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: height(8)),
                          if (!widget.hideDeviceName)
                            Flexible(
                              child: AnimatedDefaultTextStyle(
                                style: context.textTheme.titleSmall?.copyWith(color: dataColor, letterSpacing: -0.55) ??
                                    const TextStyle(),
                                duration: DeviceCard.COLORS_SWITCH_DURATION,
                                child: Text(widget.device.deviceInfo.deviceName),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (!widget.hideDetailsButton)
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: GestureDetector(
                          onTap: _onDetailsTap,
                          child: Opacity(
                            opacity: 0.0,
                            child: Container(
                              width: width(46),
                              height: width(46),
                              color: AppColors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                    // if (widget.showEffectIndication)
                    //   Positioned(
                    //     right: width(14),
                    //     bottom: height(14),
                    //     child: AnimatedSwitcher(
                    //       duration: const Duration(milliseconds: 500),
                    //       child: widget.device.effectRunning
                    //           ? Icon(Icons.whatshot_sharp, color: dataColor, size: height(18))
                    //           : Container(),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onPowerStateSet({bool isInit = false, bool? customPowerState}) {
    if (isInit) {
      powerState = widget.device.powered;
    } else {
      setState(() => powerState = customPowerState ?? widget.device.powered);
    }
  }

  void _onBrightnessStateSet({bool isInit = false, double? customBrightnessFactor}) {
    if (isInit) {
      final brightnessFactor = widget.device.brightness / AppConstants.api.MQTT_DEVICE_MAX_BRIGHTNESS;
      brightnessState = ValueNotifier<double>(brightnessFactor);
    } else {
      final brightnessFactor =
          customBrightnessFactor ?? (widget.device.brightness.toDouble() / AppConstants.api.MQTT_DEVICE_MAX_BRIGHTNESS);
      brightnessState.value = brightnessFactor;
    }
  }

  void _onPowerChange() {
    _onPowerStateSet(customPowerState: !powerState);
    widget.onPowerChanged(powerState);
  }

  void _onBrightnessChange(double value) {
    if (powerState) {
      if (prevBrightnessState != value) {
        prevBrightnessState = value;
        value = value <= 0.01
            ? 0.01
            : value >= 0.99
                ? 1.0
                : value;
        if (value >= 0.03 && value <= 1.0) {
          _onBrightnessStateSet(customBrightnessFactor: value);
          final brightnessFactor = value * AppConstants.api.MQTT_DEVICE_MAX_BRIGHTNESS;
          final brightness = brightnessFactor.toInt();
          widget.onBrightnessChanged(brightness);
        }
      }
    }
  }

  void _onDetailsTap() {
    Navigator.of(context, rootNavigator: true).pushNamed(
      Routes.DEVICE_DETAILS,
      arguments: DeviceDetailsPageArgs(
        deviceInfo: widget.device.deviceInfo,
        onPowerChanged: widget.onPowerChanged,
        onBrightnessChanged: widget.onBrightnessChanged,
        onColorChanged: widget.onColorChanged,
        onBreathChanged: widget.onBreathChanged,
        onEffectChanged: widget.onEffectChanged!,
        onEffectSpeedChanged: widget.onEffectSpeedChanged!,
        onEffectScaleChanged: widget.onEffectScaleChanged!,
      ),
    );
  }
}
