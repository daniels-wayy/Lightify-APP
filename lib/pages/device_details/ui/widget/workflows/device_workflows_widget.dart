part of 'package:lightify/pages/device_details/ui/device_details_page.dart';

class _DeviceWorkflows extends StatefulWidget {
  const _DeviceWorkflows({required this.deviceInfo});

  final DeviceInfo deviceInfo;

  @override
  State<_DeviceWorkflows> createState() => _DeviceWorkflowsState();
}

class _DeviceWorkflowsState extends State<_DeviceWorkflows> {
  late final DeviceWorkflowsCubit cubit;
  late final Device? currentDevice;

  @override
  void initState() {
    super.initState();
    cubit = context.read<DeviceWorkflowsCubit>();
    cubit.getCurrentWorkflows(widget.deviceInfo.topic);
    currentDevice = context
        .read<DevicesCubit>()
        .state
        .availableDevices
        .firstWhereOrNull((e) => e.deviceInfo.topic == widget.deviceInfo.topic);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DevicesCubit, DevicesState>(
      listener: (context, state) => context.read<DeviceWorkflowsCubit>().onReceivedData(
            widget.deviceInfo.topic,
            state.receivedDeviceWorkflows!,
          ),
      listenWhen: (p, c) => c.receivedDeviceWorkflows != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<DeviceWorkflowsCubit, DeviceWorkflowsState>(builder: (context, workflowState) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width(18)).copyWith(right: width(6)),
                  child: Row(
                    children: [
                      Text(AppConstants.strings.WORKFLOW, style: context.textTheme.titleMedium),
                      const Spacer(),
                      BouncingWidget(
                        onTap: () => _addWorkflow(workflowState.canAdd),
                        child: Padding(
                          padding: EdgeInsets.all(width(12)),
                          child: Icon(PlatformIcons(context).add, size: height(22), color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                if (workflowState.workflows.isNotEmpty) const Divider(indent: 18),
              ],
            );
          }),
          // SizedBox(height: height(14)),
          BlocSelector<DeviceWorkflowsCubit, DeviceWorkflowsState, bool>(
              selector: (state) => state.isLoading,
              builder: (context, isLoading) {
                return RepaintBoundary(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: isLoading
                        ? Padding(padding: EdgeInsets.only(left: width(18)), child: const LoadingWidget())
                        : BlocBuilder<DeviceWorkflowsCubit, DeviceWorkflowsState>(builder: (context, workflowState) {
                            if (workflowState.workflows.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return AutomaticAnimatedList<Workflow>(
                              items: workflowState.workflows,
                              keyingFunction: (item) => ValueKey(item.id),
                              itemBuilder: (context, item, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: _WorkflowItem(
                                    key: ValueKey(item.id),
                                    workflow: item,
                                    onTap: _onItemTap,
                                    onSwitchTap: _onSwitchTap,
                                    onDelete: _onDeleteWorkflow,
                                  ),
                                );
                              },
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                            );
                          }),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Future<void> _addWorkflow(bool canAdd) async {
    if (canAdd) {
      final result = await _openWorkflowForm(null);
      if (result?.workflow != null) {
        cubit.addWorkflow(result!.selectedDevices, result.workflow!);
      }
    } else {
      DialogUtil.showToast('Maximum of ${AppConstants.api.MAX_WORKFLOWS_COUNT} workflows can be scheduled');
    }
  }

  void _onSwitchTap(Workflow item) {
    if (currentDevice == null) return;
    cubit.updateWorkflow([currentDevice!], item.copyWith(isEnabled: !item.isEnabled));
  }

  void _onDeleteWorkflow(Workflow workflow) {
    if (currentDevice == null) return;
    cubit.deleteWorkflow([currentDevice!], workflow);
  }

  Future<void> _onItemTap(Workflow item) async {
    final result = await _openWorkflowForm(item);
    if (result?.workflow != null) {
      cubit.updateWorkflow(result!.selectedDevices, result.workflow!);
    }
  }

  Future<WorkflowFormPageResult?> _openWorkflowForm(Workflow? workflow) async {
    if (currentDevice == null) {
      return null;
    }
    final result = await Navigator.of(context).pushNamed(Routes.WORKFLOW_FORM,
        arguments: WorkflowFormPageArgs(
          currentDevice: currentDevice!,
          workflow: workflow,
          onDelete: () {
            if (workflow != null) {
              _onDeleteWorkflow(workflow);
            }
          },
          isExist: (id) => context.read<DeviceWorkflowsCubit>().state.workflows.any(
                (item) => item.id == id,
              ),
        ));
    if (result != null && result is WorkflowFormPageResult) {
      return result;
    }
    return null;
  }
}
