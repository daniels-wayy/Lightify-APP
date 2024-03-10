import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/data/models/home_widgets_dto.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/utils/home_widgets_config.dart';

class HomeWidgetsFunctions {
  static const widgetsKey = "devices";

  static Future<void> updateWidgets(HomeWidgetsDTO dto) async {
    final json = dto.toJson();
    final encodedJson = jsonEncode(json);
    await HomeWidget.saveWidgetData<String>(widgetsKey, encodedJson);
    await HomeWidget.updateWidget(
      iOSName: HomeWidgetsConfig.iOSName,
    );
  }

  static Future<HomeWidgetsDTO?> getWidgetState() async {
    final currentData = await HomeWidget.getWidgetData<String?>(widgetsKey, defaultValue: null);
    if (currentData != null) {
      final decodedJson = jsonDecode(currentData) as Map<String, dynamic>;
      if (decodedJson.isNotEmpty) {
        final dto = HomeWidgetsDTO.fromJson(decodedJson);
        return dto;
      }
    }
    return null;
  }
}
