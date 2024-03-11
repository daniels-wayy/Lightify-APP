import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lightify/pages/main/settings/home_widgets/data/models/home_widget_device_entity.dart';

part 'home_widgets_dto.g.dart';

@JsonSerializable()
class HomeWidgetsDTO {
  final List<HomeWidgetDeviceEntity> smallWidget;
  final List<HomeWidgetDeviceEntity> mediumWidget;
  final List<HomeWidgetDeviceEntity> bigWidget;

  const HomeWidgetsDTO({required this.smallWidget, required this.mediumWidget, required this.bigWidget});

  factory HomeWidgetsDTO.fromJson(Map<String, dynamic> json) => _$HomeWidgetsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$HomeWidgetsDTOToJson(this);
}
