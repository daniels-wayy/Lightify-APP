import 'package:lightify/config.dart';
import 'package:lightify/core/data/model/house.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/entry_point.dart';

void main() {
  final houses = <House>[
    House(name: 'My home', remotes: AppConstants.api.dnRemotes, isPrimary: true),
    House(name: 'Danny\'s home', remotes: AppConstants.api.dsRemotes),
  ];

  Config.init(
    houses: houses,
    showHomeSelectorDefault: true,
  );

  run();
}
