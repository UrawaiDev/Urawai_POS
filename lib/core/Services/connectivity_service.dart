import 'dart:async';

import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  StreamSubscription<ConnectivityResult> _subscription;
  StreamController<ConnectivityResult> _networkStatusController;

  StreamSubscription<ConnectivityResult> get subscription => _subscription;
  StreamController<ConnectivityResult> get networkStatusController =>
      _networkStatusController;

  ConnectivityService() {
    _networkStatusController = StreamController<ConnectivityResult>();
    _invokeNetworkStatusListen();
  }

  void _invokeNetworkStatusListen() async {
    _networkStatusController.sink.add(await Connectivity().checkConnectivity());

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _networkStatusController.sink.add(result);
    });
  }

  void disposeStream() {
    _subscription.cancel();
    _networkStatusController.close();
  }
}
