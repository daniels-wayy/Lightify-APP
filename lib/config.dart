import 'package:lightify/core/data/model/house.dart';

class Config {
  const Config._();

  static List<House> _houses = [];
  static List<House> get houses => _houses;

  static bool _showHomeSelectorDefault = true;
  static bool get showHomeSelectorDefault => _showHomeSelectorDefault;

  static House get primaryHouse => _houses.firstWhere((house) => house.isPrimary);

  static void init({
    required final List<House> houses,
    required final bool showHomeSelectorDefault,
  }) {
    _houses = houses;
    _showHomeSelectorDefault = showHomeSelectorDefault;
  }
}
