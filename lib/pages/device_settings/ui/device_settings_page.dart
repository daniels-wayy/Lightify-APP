import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/data/model/device_settings.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/bloc/devices/devices_state.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/dialog_util.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/utils/vibration_util.dart';
import 'package:lightify/core/ui/widget/common/fading_edge_widget.dart';
import 'package:lightify/core/ui/widget/progress/loading_widget.dart';
import 'package:lightify/di/di.dart';
import 'package:lightify/pages/device_settings/domain/args/device_settings_page_args.dart';
import 'package:lightify/pages/device_settings/ui/cubit/device_settings_cubit.dart';
import 'package:lightify/pages/main/settings/settings/ui/widgets/settings_app_bar_widget.dart';

class DeviceSettingsPage extends StatefulWidget {
  const DeviceSettingsPage({super.key, required this.args});

  final DeviceSettingsPageArgs args;

  @override
  State<DeviceSettingsPage> createState() => _DeviceSettingsPageState();
}

class _DeviceSettingsPageState extends State<DeviceSettingsPage> {
  late final TextEditingController portController = TextEditingController();
  late final TextEditingController currentLimitController = TextEditingController();
  late final TextEditingController ledCountController = TextEditingController();
  late final TextEditingController gmtController = TextEditingController();

  late final DevicesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<DevicesCubit>();
    context.read<DeviceSettingsCubit>().fetch(widget.args.deviceInfo.topic);
  }

  @override
  void dispose() {
    super.dispose();
    portController.dispose();
    currentLimitController.dispose();
    ledCountController.dispose();
    gmtController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceSettingsCubit, DeviceSettingsState>(
      listener: (context, state) {
        portController.text = state.port.toString();
        currentLimitController.text = state.currentLimit.toString();
        ledCountController.text = state.ledCount.toString();
        gmtController.text = state.gmt.toString();
      },
      listenWhen: (p, c) => p.isLoading && !c.isLoading,
      child: BlocListener<DevicesCubit, DevicesState>(
        listener: (context, state) => context.read<DeviceSettingsCubit>().onReceivedData(
              widget.args.deviceInfo.topic,
              state.receivedDeviceSettings!,
            ),
        listenWhen: (p, c) => c.receivedDeviceSettings != null,
        child: Scaffold(
          backgroundColor: AppColors.fullBlack,
          body: BlocSelector<DeviceSettingsCubit, DeviceSettingsState, bool>(
              selector: (state) => state.isLoading,
              builder: (context, isLoading) {
                return RepaintBoundary(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: isLoading
                        ? const Center(child: LoadingWidget())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height(26)),
                              SettingsAppBar(onBack: () => Navigator.of(context).pop(), title: 'Device settings'),
                              SizedBox(height: height(14)),
                              Expanded(
                                child: FadingEdge(
                                  scrollDirection: Axis.vertical,
                                  child: ListView(
                                    padding: EdgeInsets.symmetric(horizontal: width(18), vertical: height(12)).copyWith(
                                      bottom: ScreenUtil.bottomPadding + height(70),
                                    ),
                                    children: [
                                      SizedBox(height: height(18)),
                                      _buildDeviceName(),
                                      SizedBox(height: height(50)),
                                      if (widget.args.deviceInfo.firmwareVersion != null &&
                                          widget.args.deviceInfo.firmwareVersion!.isVersion) ...[
                                        _buildDeviceVersion(),
                                        SizedBox(height: height(50)),
                                      ],
                                      _buildDeviceIP(),
                                      SizedBox(height: height(42)),
                                      _buildTextFieldRow(
                                        title: 'Device port:',
                                        hint: 'Enter port',
                                        controller: portController,
                                      ),
                                      SizedBox(height: height(32)),
                                      _buildTextFieldRow(
                                        title: 'Current limit (mAh):',
                                        hint: 'Enter limit(mAh)',
                                        controller: currentLimitController,
                                      ),
                                      SizedBox(height: height(32)),
                                      _buildTextFieldRow(
                                        title: 'LED count:',
                                        hint: 'Enter count',
                                        controller: ledCountController,
                                      ),
                                      SizedBox(height: height(32)),
                                      _buildTextFieldRow(
                                        title: 'Time zone (GMT):',
                                        hint: 'Enter time zone',
                                        controller: gmtController,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              _buildSaveCTA(),
                            ],
                          ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget _buildDeviceName() {
    return Row(
      children: [
        Text(
          'Device name: ',
          style: context.textTheme.titleSmall?.copyWith(
            fontSize: height(18),
            fontWeight: FontWeight.w500,
            letterSpacing: -0.6,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: _onEditTap,
          behavior: HitTestBehavior.translucent,
          child: BlocBuilder<DevicesCubit, DevicesState>(builder: (context, _) {
            return Text(
              widget.args.deviceInfo.displayDeviceName,
              style: context.textTheme.displayMedium?.copyWith(
                fontSize: height(18),
                color: AppColors.gray200,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.05,
              ),
            );
          }),
        ),
        SizedBox(width: width(12)),
        GestureDetector(
          onTap: _onEditTap,
          behavior: HitTestBehavior.translucent,
          child: Icon(Icons.edit_outlined, size: height(16), color: AppColors.gray200),
        ),
      ],
    );
  }

  Widget _buildTextFieldRow({
    required String title,
    required String hint,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            fontSize: height(18),
            fontWeight: FontWeight.w500,
            letterSpacing: -0.6,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: width(120),
          child: TextField(
            controller: controller,
            style: context.textTheme.displayMedium,
            decoration: InputDecoration(hintText: hint),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceIP() {
    return Row(
      children: [
        Text(
          'IP Address: ',
          style: context.textTheme.titleSmall?.copyWith(
            fontSize: height(18),
            fontWeight: FontWeight.w500,
            letterSpacing: -0.6,
          ),
        ),
        const Spacer(),
        BlocBuilder<DeviceSettingsCubit, DeviceSettingsState>(builder: (context, state) {
          return GestureDetector(
            onTap: () => _saveIP(state.ip),
            onLongPress: () => _saveIP(state.ip),
            child: Text(
              state.ip,
              style: context.textTheme.displayMedium?.copyWith(
                fontSize: height(18),
                color: AppColors.gray200,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.05,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDeviceVersion() {
    return Row(
      children: [
        Text(
          'Device version:',
          style: context.textTheme.titleSmall?.copyWith(
            fontSize: height(18),
            fontWeight: FontWeight.w500,
            letterSpacing: -0.6,
          ),
        ),
        const Spacer(),
        Text(
              widget.args.deviceInfo.firmwareVersion!.version.toString(),
              style: context.textTheme.displayMedium?.copyWith(
                fontSize: height(18),
                color: AppColors.gray200,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.05,
              ),
            ),
      ],
    );
  }

  Widget _buildSaveCTA() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: height(14) + MediaQuery.of(context).padding.bottom,
          left: width(32),
          right: width(32),
          top: height(14)),
      child: MaterialButton(
        onPressed: _onSave,
        color: AppColors.primary100,
        height: height(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            'Save',
            style: context.textTheme.titleSmall?.copyWith(
              fontSize: height(18),
              fontWeight: FontWeight.w500,
              letterSpacing: -0.6,
            ),
          ),
        ),
      ),
    );
  }

  void _onSave() {
    final port = int.tryParse(portController.text) ?? 0;
    final currentLimit = int.tryParse(currentLimitController.text) ?? 0;
    final ledCount = int.tryParse(ledCountController.text) ?? 0;
    final timeZone = int.tryParse(gmtController.text);

    if (port > 0 && currentLimit > 0 && ledCount > 0 && timeZone != null) {
      context.read<DeviceSettingsCubit>().onSave(DeviceSettings(
            topic: widget.args.deviceInfo.topic,
            port: port,
            currentLimit: currentLimit,
            ledCount: ledCount,
            gmt: timeZone,
            ip: context.read<DeviceSettingsCubit>().state.ip,
          ));
      Navigator.of(context).pop();
      DialogUtil.showToast('Changes saved. Resetting...');
    }
  }

  Future<void> _saveIP(String data) async {
    Clipboard.setData(ClipboardData(text: data));
    VibrationUtil.vibrate();
    DialogUtil.showToast('IP copied');
  }

  Future<void> _onEditTap() async {
    final device = getIt<DevicesCubit>().state.findDeviceById(widget.args.deviceInfo.topic);

    final result = await showTextInputDialog(
      context: context,
      textFields: [
        DialogTextField(
            maxLines: 1,
            maxLength: 16,
            autocorrect: true,
            keyboardType: TextInputType.text,
            initialText: device?.deviceInfo.displayDeviceName,
            hintText: AppConstants.strings.NEW_DEVICE_NAME,
            textCapitalization: TextCapitalization.sentences),
      ],
      title: AppConstants.strings.RENAME_DEVICE,
      okLabel: AppConstants.strings.SAVE,
      fullyCapitalizedForMaterial: false,
    );
    if (result != null && result.isNotEmpty) {
      if (result.first.length <= 2) {
        DialogUtil.showToast('The name must be at least 3 characters long.');
        return;
      }
      cubit.renameDevice(widget.args.deviceInfo.topic, result.first.trim().capitalizeFirstLetter);
    }
  }
}
