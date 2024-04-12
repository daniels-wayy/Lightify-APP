import 'package:lightify/core/data/model/workflow.dart';

class WorkflowFormPageArgs {
  final Workflow? workflow;
  final void Function()? onDelete;
  final bool Function(int id) isExist;
  const WorkflowFormPageArgs({
    required this.workflow,
    required this.onDelete,
    required this.isExist,
  });
}
