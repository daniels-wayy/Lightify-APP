import 'package:lightify/config.dart';
import 'package:lightify/core/data/model/house.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/entry_point.dart';

void main() {
  final houses = <House>[
    House(name: 'My home', remotes: AppConstants.api.dsRemotes, isPrimary: true),
    House(name: 'Nick\'s home', remotes: AppConstants.api.dnRemotes),
  ];

  Config.init(
    houses: houses,
    showHomeSelectorDefault: false,
  );

  run();
}
