import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:turing_deal/data/api/yahooFinance.dart';

class AppStateProvider with ChangeNotifier {

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  Map<String, dynamic> _bigPictureData = {};

  AppStateProvider(BuildContext context){
    //TODO the context is here to get user preferences in the future
  }

  void loadData() async{
    await initConnectivity();

    if(hasInternetConnection()){
      this._bigPictureData = await YahooFinance.getDailyData("^GSPC");
      this.notifyListeners();
    }else{
      //TODO snackbar
      print('Check internet connection');
    }
  }

  Map<String, dynamic> getBigPictureData() {
    return this._bigPictureData;
  }

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

  void refresh() {
    notifyListeners();
  }


}
