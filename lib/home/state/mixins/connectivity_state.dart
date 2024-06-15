import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin ConnectivityState {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      List<ConnectivityResult> result = await Connectivity().checkConnectivity();
      for (var item in result) {
        _updateConnectionStatus(item);
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult? result) async {
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
    if (_connectionStatus == ConnectivityResult.wifi.toString() ||
        _connectionStatus == ConnectivityResult.mobile.toString()) {
      return true;
    } else {
      return false;
    }
  }
}
