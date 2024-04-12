import 'package:lightify/core/data/model/workflow.dart';

class WorkflowResponse {
  final String topic;
  final List<Workflow> items;
  const WorkflowResponse({required this.topic, required this.items});
}
