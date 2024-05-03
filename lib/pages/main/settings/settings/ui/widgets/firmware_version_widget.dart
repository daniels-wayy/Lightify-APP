part of 'package:lightify/pages/main/settings/settings/ui/settings_page.dart';

class _FirmwareVersion extends StatelessWidget {
  const _FirmwareVersion();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirmwareUpdateCubit, FirmwareUpdateState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(context, state),
            if (state.isChecked && state.hasUpdates) ...[
              SizedBox(height: height(12)),
              const Divider(),
            ],
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: !state.isGettingLatestAvailableVersion && state.isChecked && state.hasUpdates
                  ? _buildDevicesList(state)
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderRow(BuildContext context, FirmwareUpdateState state) {
    return Row(
      children: [
        Text(
          'Firmware update:',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        RepaintBoundary(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: () {
              if (state.isGettingLatestAvailableVersion) {
                return const LoadingWidget();
              }
              if (state.isChecked) {
                if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
                  return _buildTextButton(
                    context: context,
                    title: '${state.errorMessage} Tap to retry',
                    onTap: context.read<FirmwareUpdateCubit>().checkVersion,
                    color: Colors.red,
                  );
                }
                if (state.hasUpdates) {
                  if (state.isAllDevicesWereUpdated) {
                    return _buildTextButton(
                      context: context,
                      title: 'Up to date (${state.latestAvailableVersion})',
                      color: Colors.green,
                      onTap: context.read<FirmwareUpdateCubit>().checkVersion,
                    );
                  }
                  return _buildTextButton(
                    context: context,
                    title: 'Update all',
                    onTap: context.read<FirmwareUpdateCubit>().updateAll,
                  );
                } else {
                  return _buildTextButton(
                    context: context,
                    title: 'Up to date (${state.latestAvailableVersion})',
                    color: Colors.green,
                    onTap: context.read<FirmwareUpdateCubit>().checkVersion,
                  );
                }
              }
              return _buildTextButton(
                context: context,
                title: 'Check for update',
                onTap: context.read<FirmwareUpdateCubit>().checkVersion,
              );
            }(),
          ),
        ),
      ],
    );
  }

  Widget _buildTextButton({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
    Color? color,
    EdgeInsetsGeometry? padding,
  }) {
    return BouncingWidget(
      onTap: onTap,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Text(
          title,
          style: context.textTheme.displayMedium?.copyWith(
            color: color ?? Colors.lightBlueAccent,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDevicesList(FirmwareUpdateState state) {
    return Column(
      children: [
        SizedBox(height: height(6)),
        ListView.separated(
          itemBuilder: (context, index) => _buildDevice(context, state.devicesNeedsAnUpdate[index], state),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: state.devicesNeedsAnUpdate.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
        ),
      ],
    );
  }

  Widget _buildDevice(BuildContext context, Device device, FirmwareUpdateState state) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height(14)),
      child: Row(
        children: [
          Text(
            device.deviceInfo.displayDeviceName,
            style: context.textTheme.displayMedium?.copyWith(
              fontSize: height(15),
              color: AppColors.gray200,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.05,
            ),
          ),
          const Spacer(),
          Text(
            '${device.deviceInfo.firmwareVersion!.version}',
            style: context.textTheme.displayMedium?.copyWith(
              fontSize: height(15),
              color: AppColors.gray200,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.05,
            ),
          ),
          const SizedBox(width: 6.0),
          Icon(Icons.arrow_right_alt_rounded, color: Colors.grey.shade300, size: 14),
          const SizedBox(width: 6.0),
          Text(
            '${state.latestAvailableVersion.version}',
            style: context.textTheme.displayMedium?.copyWith(
              fontSize: height(15),
              color: Colors.grey.shade300,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.05,
            ),
          ),
          SizedBox(width: width(8)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: () {
              final status = state.updateStatuses[device.deviceInfo.topic];
              if (status != null) {
                return _buildStatus(context, status);
              }
              return _buildUpdateButton(device, context);
            }(),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(Device device, BuildContext context) {
    return _buildTextButton(
      context: context,
      title: 'Update',
      onTap: () => context.read<FirmwareUpdateCubit>().updateDevice(device),
    );
  }

  Widget _buildStatus(BuildContext context, FirmwareUpdateStatus status) {
    Text buildText(String text, [Color? color]) {
      return Text(
        text,
        style: context.textTheme.displayMedium?.copyWith(
          fontSize: height(14),
          color: color ?? Colors.lightBlueAccent,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 4,
      );
    }

    final itemWidth = width(35);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: itemWidth,
        maxWidth: MediaQuery.of(context).size.width / 2.5,
      ),
      child: status.when(
        waiting: () => const LoadingWidget(),
        started: () => const LoadingWidget(),
        progress: (percent) => buildText('$percent%'),
        finished: () => const Icon(Icons.check, color: Colors.green, size: 16.0),
        error: (msg) => buildText(msg, Colors.red),
      ),
    );
  }
}
