import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/storages/common_storage.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/di/di.dart';

class ReorderUtil {
  static const _defaultGroupOrder = [
    'Kitchen',
    'Living Room',
    'Bedroom',
    'Office',
  ];

  static List<String>? _order;

  static Map<String, List<Device>> getDevicesPerOrder(List<Device> devices) {
    final order = _order ?? getDevicesGroupOrder();
    final updatedDevices = [...devices];
    final groupedDevices = updatedDevices.groupBy((p0) => p0.deviceInfo.deviceGroup);

    Map<String, int> indexMap = {};
    for (int i = 0; i < order.length; i++) {
      indexMap[order[i]] = i;
    }

    List<String> sortedGroupNames = groupedDevices.keys.toList()
      ..sort((a, b) {
        int indexA = indexMap[a] ?? order.length;
        int indexB = indexMap[b] ?? order.length;
        return indexA.compareTo(indexB);
      });

    Map<String, List<Device>> sortedMap = {};
    for (String groupName in sortedGroupNames) {
      sortedMap[groupName] = groupedDevices[groupName]!;
    }

    return sortedMap;
  }

  static Future<void> updateDevicesGroupOrder(List<String> newOrder) async {
    _order = newOrder;
    return getIt<CommonStorage>().storeDevicesGroupOrder(newOrder);
  }

  static List<String> getDevicesGroupOrder() {
    final order = getIt<CommonStorage>().getDevicesGroupOrder() ?? _defaultGroupOrder;
    _order = order;
    return _order!;
  }
}
