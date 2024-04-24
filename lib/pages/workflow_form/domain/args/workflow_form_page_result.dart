import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/workflow.dart';

class WorkflowFormPageResult {
  final List<Device> selectedDevices;
  final Workflow? workflow;
  const WorkflowFormPageResult({required this.selectedDevices, required this.workflow});
}
