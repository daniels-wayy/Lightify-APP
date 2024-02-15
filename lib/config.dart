import 'package:lightify/core/data/model/house.dart';

class Config {
  const Config._();

  static List<House> _houses = [];
  static List<House> get houses => _houses;

  static House get primaryHouse => _houses.firstWhere((house) => house.isPrimary);

  static void init({
    required final List<House> houses,
  }) {
    _houses = houses;
  }
}
