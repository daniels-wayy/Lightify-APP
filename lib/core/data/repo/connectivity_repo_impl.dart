import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/domain/repo/connectivity_repo.dart';

@Injectable(as: ConnectivityRepo)
class ConnectivityRepoImpl implements ConnectivityRepo {
  final Connectivity connectivity;

  ConnectivityRepoImpl({required this.connectivity});

  @override
  Stream<bool> connectedToNet() async* {
    yield* connectivity.onConnectivityChanged.map((event) => (event != ConnectivityResult.none));
  }
}
