part of 'home_widgets_config_cubit.dart';

@JsonSerializable(
  includeIfNull: false,
  createFactory: false,
  explicitToJson: true,
)
@freezed
abstract class HomeWidgetsConfigState with _$HomeWidgetsConfigState {
  const HomeWidgetsConfigState._();
  const factory HomeWidgetsConfigState({
    required List<HomeWidgetDeviceEntity> smallWidget,
    required List<HomeWidgetDeviceEntity> mediumWidget,
    required List<HomeWidgetDeviceEntity> bigWidget,
    @Default(false) bool isWidgetsAvailable,
  }) = _HomeWidgetsConfigState;

  factory HomeWidgetsConfigState.initial() {
    return const HomeWidgetsConfigState(
      smallWidget: [],
      mediumWidget: [],
      bigWidget: [],
    );
  }

  factory HomeWidgetsConfigState.fromJson(Map<String, dynamic> json) => _$HomeWidgetsConfigStateFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HomeWidgetsConfigStateToJson(this);

  List<HomeWidgetDeviceEntity> get allWidgets {
    return [...smallWidget, ...mediumWidget, ...bigWidget];
  }

  bool get isNotEmpty {
    return smallWidget.isNotEmpty && mediumWidget.isNotEmpty && bigWidget.isNotEmpty;
  }

  HomeWidgetsDTO get widgetsDTO {
    return HomeWidgetsDTO(smallWidget: smallWidget, mediumWidget: mediumWidget, bigWidget: bigWidget);
  }
}
