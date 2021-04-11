import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

class ConnectivityState{

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await (Connectivity().checkConnectivity());
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        _connectionStatus = result.toString();
        break;
      default:
        _connectionStatus = 'Failed to get connectivity.';
        break;
    }
  }


  bool hasInternetConnection() {
    if(_connectionStatus == ConnectivityResult.wifi.toString() || _connectionStatus == ConnectivityResult.mobile.toString()){
      return true;
    }
    else{
      return false;
    }
  }
}