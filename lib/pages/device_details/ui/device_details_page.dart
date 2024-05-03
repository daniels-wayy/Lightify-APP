import 'dart:io';
import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:automatic_animated_list/automatic_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lightify/core/data/model/color_preset.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/device_info.dart';
import 'package:lightify/core/data/model/effect_entity.dart';
import 'package:lightify/core/data/model/workflow.dart';
import 'package:lightify/core/ui/animation/scale_fade_animation.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/bloc/devices/devices_state.dart';
import 'package:lightify/core/ui/bloc/user_pref/user_pref_cubit.dart';
import 'package:lightify/core/ui/bloc/user_pref/user_pref_state.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/routes/root_routes.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/date_time_util.dart';
import 'package:lightify/core/ui/utils/dialog_util.dart';
import 'package:lightify/core/ui/utils/function_util.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/utils/vibration_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/core/ui/widget/common/common_slider.dart';
import 'package:lightify/core/ui/widget/common/fading_edge_widget.dart';
import 'package:lightify/core/ui/widget/progress/loading_widget.dart';
import 'package:lightify/pages/device_details/domain/model/device_details_page_args.dart';
import 'package:lightify/pages/device_details/domain/model/device_rgb_color_input_dto.dart';
import 'package:lightify/pages/device_details/ui/cubit/device_workflows_cubit.dart';
import 'package:lightify/pages/device_details/ui/widget/slideable_time/slideable_time_widget.dart';
import 'package:lightify/pages/device_settings/domain/args/device_settings_page_args.dart';
import 'package:lightify/pages/device_settings/domain/args/device_settings_page_result.dart';
import 'package:lightify/pages/main/home/ui/widget/device_card.dart';
import 'package:lightify/pages/workflow_form/domain/args/workflow_form_page_args.dart';
import 'package:collection/collection.dart';
import 'package:lightify/pages/workflow_form/domain/args/workflow_form_page_result.dart';

part 'package:lightify/pages/device_details/ui/widget/details_device_card_widget.dart';
part 'package:lightify/pages/device_details/ui/widget/details_color_picker_widget.dart';
part 'package:lightify/pages/device_details/ui/widget/details_preset_colors_widget.dart';
part 'package:lightify/pages/device_details/ui/widget/details_breath_slider_widget.dart';
part 'package:lightify/pages/device_details/ui/widget/details_effects_controls_widget.dart';
part 'package:lightify/pages/device_details/ui/widget/workflows/device_workflows_widget.dart';
part 'package:lightify/pages/device_details/ui/widget/workflows/workflow_item_widget.dart';
part 'package:lightify/pages/device_details/ui/widget/details_upcoming_workflow_widget.dart';

class DeviceDetailsPage extends StatefulWidget {
  const DeviceDetailsPage({super.key, required this.args});

  final DeviceDetailsPageArgs args;

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  var customColorDTO = const DeviceRGBColorInputDTO.empty();
  var customColorPreset = ColorPreset.empty();

  late final UserPrefCubit userPrefCubit;
  late final DevicesCubit devicesCubit;

  @override
  void initState() {
    userPrefCubit = context.read<UserPrefCubit>();
    devicesCubit = context.read<DevicesCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesCubit, DevicesState>(builder: (_, state) {
      final device = state.findDeviceById(widget.args.deviceInfo.topic);
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: device == null
            ? Scaffold(
                backgroundColor: AppColors.fullBlack,
                appBar: _buildAppBar(context, null),
                body: const Center(child: LoadingWidget()),
              )
            : Scaffold(
                backgroundColor: AppColors.fullBlack,
                appBar: _buildAppBar(context, device),
                body: FadingEdge(
                  scrollDirection: Axis.vertical,
                  stops: const [0.0, 0.03, 0.96, 1.0],
                  child: ListView(
                    controller: ScrollController(),
                    padding: EdgeInsets.only(bottom: height(64) + ScreenUtil.bottomPadding, top: height(18)),
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      _DetailsDeviceCardWidget(
                        device: device,
                        onPowerChanged: widget.args.onPowerChanged,
                        onBrightnessChanged: widget.args.onBrightnessChanged,
                      ),
                      SizedBox(height: height(42)),
                      _DetailsColorPickerWidget(
                        device: device,
                        onColorChanged: widget.args.onColorChanged,
                        onCustomColorTap: _onCustomColorTap,
                      ),
                      SizedBox(height: height(26)),
                      _DetailsEffectsControlsWidget(
                        device: device,
                        onEffectChanged: widget.args.onEffectChanged,
                        onEffectSpeedChanged: widget.args.onEffectSpeedChanged,
                        onEffectScaleChanged: widget.args.onEffectScaleChanged,
                      ),
                      SizedBox(height: height(42)),
                      _DetailsPresetColorsWidget(
                        onPresetTap: widget.args.onColorChanged,
                        onColorPresetRemove: _onPresetRemove,
                        onColorPresetAdd: () => _onColorPresetAdd(device.color),
                      ),
                      SizedBox(height: height(32)),
                      _DeviceWorkflows(deviceInfo: widget.args.deviceInfo),
                      SizedBox(height: height(14) + MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ),
      );
    });
  }

  AppBar _buildAppBar(BuildContext context, Device? device) {
    return AppBar(
      leading: BouncingWidget(
        onTap: Navigator.of(context).pop,
        child: Icon(PlatformIcons(context).back, size: height(26), color: Colors.white),
      ),
      actions: [
        BouncingWidget(
          onTap: _openSettings,
          child: Padding(
            padding: EdgeInsets.only(right: width(12)),
            child: Icon(PlatformIcons(context).settings, size: height(22), color: Colors.white),
          ),
        ),
      ],
      backgroundColor: AppColors.fullBlack,
      centerTitle: true,
      elevation: 0.0,
      toolbarHeight: kToolbarHeight + height(14),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<DevicesCubit, DevicesState>(builder: (context, _) {
            return Text(
              widget.args.deviceInfo.displayDeviceName,
              style: context.textTheme.titleMedium,
            );
          }),
          if (device != null) _DetailsUpcomingWorkflow(device),
        ],
      ),
    );
  }

  Future<void> _onCustomColorTap() async {
    final result = await showTextInputDialog(
      context: context,
      textFields: [
        DialogTextField(
            maxLines: 1,
            maxLength: 3,
            autocorrect: false,
            keyboardType: TextInputType.number,
            hintText: AppConstants.strings.R,
            validator: (value) => (value ?? '').isEmpty ? 'R required' : null),
        DialogTextField(
            maxLines: 1,
            maxLength: 3,
            autocorrect: false,
            keyboardType: TextInputType.number,
            hintText: AppConstants.strings.G,
            validator: (value) => (value ?? '').isEmpty ? 'G required' : null),
        DialogTextField(
            maxLines: 1,
            maxLength: 3,
            autocorrect: false,
            keyboardType: TextInputType.number,
            hintText: AppConstants.strings.B,
            validator: (value) => (value ?? '').isEmpty ? 'B required' : null),
      ],
      title: AppConstants.strings.CUSTOM_COLOR,
    );
    if (result != null && result.isNotEmpty) {
      final r = int.tryParse(result[0]) ?? 0;
      final g = int.tryParse(result[1]) ?? 0;
      final b = int.tryParse(result[2]) ?? 0;
      final color = Color.fromRGBO(r > 255 ? 255 : r, g > 255 ? 255 : g, b > 255 ? 255 : b, 1.0);
      widget.args.onColorChanged?.call(HSVColor.fromColor(color));
    }
  }

  Future<void> _onColorPresetAdd(HSVColor color) async {
    final result = await showTextInputDialog(
      context: context,
      textFields: [
        DialogTextField(
            maxLines: 1,
            maxLength: 16,
            autocorrect: true,
            keyboardType: TextInputType.text,
            hintText: AppConstants.strings.PRESET_NAME,
            textCapitalization: TextCapitalization.sentences),
      ],
      title: AppConstants.strings.ADD_COLOR_PRESET,
      okLabel: AppConstants.strings.SAVE,
      fullyCapitalizedForMaterial: false,
    );
    if (result != null && result.isNotEmpty) {
      userPrefCubit.addColorPreset(ColorPreset(color: color, colorName: result.first.capitalizeFirstLetter));
    }
  }

  Future<void> _onPresetRemove(ColorPreset preset) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      okLabel: AppConstants.strings.DELETE,
      title: AppConstants.strings.DELETE_PRESET_QUESTION,
      fullyCapitalizedForMaterial: false,
    );
    if (result == OkCancelResult.ok) {
      userPrefCubit.removeColorPreset(preset);
    }
  }

  void _openSettings() {
    Navigator.of(context)
        .pushNamed(
      Routes.DEVICE_SETTINGS,
      arguments: DeviceSettingsPageArgs(deviceInfo: widget.args.deviceInfo),
    )
        .then((result) {
      if (result != null && (result is DeviceSettingsPageResult && result.isFactoryReset)) {
        context.read<DeviceWorkflowsCubit>().resetState();
      }
    });
  }
}
