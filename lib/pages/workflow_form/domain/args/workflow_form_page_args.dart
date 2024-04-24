import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/workflow.dart';

class WorkflowFormPageArgs {
  final Device currentDevice;
  final Workflow? workflow;
  final void Function()? onDelete;
  final bool Function(int id) isExist;
  const WorkflowFormPageArgs({
    required this.currentDevice,
    required this.workflow,
    required this.onDelete,
    required this.isExist,
  });
}
