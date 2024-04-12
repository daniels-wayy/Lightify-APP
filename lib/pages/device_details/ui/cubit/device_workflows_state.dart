part of 'device_workflows_cubit.dart';

@freezed
class DeviceWorkflowsState with _$DeviceWorkflowsState {
  const DeviceWorkflowsState._();
  const factory DeviceWorkflowsState({
    @Default(false) bool isLoading,
    required List<Workflow> workflows,
  }) = _DeviceWorkflowsState;

  factory DeviceWorkflowsState.initial() => const DeviceWorkflowsState(
        workflows: [],
      );

  bool get canAdd => workflows.length < AppConstants.api.MAX_WORKFLOWS_COUNT;
}
