import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin ConnectivityState {
  String _connectionStatus = 'Unknown';

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final List<ConnectivityResult> result = await Connectivity().checkConnectivity();
      for (final ConnectivityResult item in result) {
        await _updateConnectionStatus(item);
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
      case ConnectivityResult.bluetooth:
        // TODO: Handle this case.
        break;
      case ConnectivityResult.ethernet:
        // TODO: Handle this case.
        break;
      case ConnectivityResult.vpn:
        // TODO: Handle this case.
        break;
      case ConnectivityResult.other:
        // TODO: Handle this case.
        break;
      case null:
        // TODO: Handle this case.
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
