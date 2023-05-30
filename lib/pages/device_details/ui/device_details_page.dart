import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lightify/core/data/model/color_preset.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/ui/animation/scale_fade_animation.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/bloc/devices/devices_state.dart';
import 'package:lightify/core/ui/bloc/user_pref/user_pref_cubit.dart';
import 'package:lightify/core/ui/bloc/user_pref/user_pref_state.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/core/ui/widget/helpers/custom_hold_detector.dart';
import 'package:lightify/pages/device_details/domain/model/device_details_page_args.dart';
import 'package:lightify/pages/device_details/domain/model/device_rgb_color_input_dto.dart';
import 'package:lightify/pages/main/home/ui/widget/device_card.dart';

part 'package:lightify/pages/device_details/ui/widget/details_device_card_widget.dart';
part 'package:lightify/pages/device_details/ui/widget/details_color_picker_widget.dart';
part 'package:lightify/pages/device_details/ui/widget/details_preset_colors_widget.dart';
part 'package:lightify/pages/device_details/ui/widget/details_breath_slider_widget.dart';

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

  @override
  void initState() {
    userPrefCubit = context.read<UserPrefCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fullBlack,
      appBar: _buildAppBar(context),
      body: BlocBuilder<DevicesCubit, DevicesState>(builder: (_, state) {
        final device = state.findDeviceById(widget.args.deviceInfo.topic);
        if (device == null) {
          return const SizedBox.shrink();
        }
        return ListView(
          // padding: EdgeInsets.only(top: height(12)),
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            SizedBox(height: height(14)),
            _DetailsDeviceCardWidget(
              device: device,
              onPowerChanged: widget.args.onPowerChanged,
              onBrightnessChanged: widget.args.onBrightnessChanged,
            ),
            SizedBox(height: height(42)),
            _DetailsBreathSliderWidget(
              device: device,
              onBreathChanged: widget.args.onBreathChanged,
            ),
            SizedBox(height: height(42)),
            _DetailsPresetColorsWidget(
              onPresetTap: widget.args.onColorChanged,
              onColorPresetRemove: _onPresetRemove,
              onColorPresetAdd: () => _onColorPresetAdd(device.color),
            ),
            SizedBox(height: height(42)),
            _DetailsColorPickerWidget(
              device: device,
              onColorChanged: widget.args.onColorChanged,
              onCustomColorTap: _onCustomColorTap,
            ),
          ],
        );
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: BouncingWidget(
        onTap: Navigator.of(context).pop,
        child: Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: height(22)),
      ),
      backgroundColor: AppColors.fullBlack,
      centerTitle: true,
      elevation: 0.0,
      toolbarHeight: height(62),
      title: Column(
        children: [
          Text(
            widget.args.deviceInfo.deviceName,
            style: context.textTheme.titleMedium?.copyWith(
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: height(2)),
          Text(
            widget.args.deviceInfo.deviceGroup,
            style: context.textTheme.displaySmall?.copyWith(
              color: AppColors.gray200,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.25,
            ),
          ),
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
}
