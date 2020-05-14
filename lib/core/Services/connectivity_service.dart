import 'dart:async';

import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  // StreamSubscription<ConnectivityResult> _subscription;
  StreamController<ConnectivityResult> _networkStatusController =
      StreamController<ConnectivityResult>();

  // StreamSubscription<ConnectivityResult> get subscription => _subscription;
  StreamController<ConnectivityResult> get networkStatusController =>
      _networkStatusController;

  ConnectivityService() {
    // _invokeNetworkStatusListen();
    try {
      _checkConnectionAtFirstConnection();
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        _networkStatusController.sink.add(result);
      });
    } catch (e) {
      throw (e.toString());
    }
  }
  void _checkConnectionAtFirstConnection() async {
    _networkStatusController.sink.add(await Connectivity().checkConnectivity());
  }

  // void _invokeNetworkStatusListen() async {
  //   _networkStatusController.sink.add(await Connectivity().checkConnectivity());

  //   _subscription = Connectivity()
  //       .onConnectivityChanged
  //       .listen((ConnectivityResult result) {
  //     _networkStatusController.sink.add(result);
  //   });
  // }

  void disposeStream() {
    try {
      // _subscription?.cancel();
      _networkStatusController.close();
    } catch (e) {
      print(e.toString());
    }
  }
}
