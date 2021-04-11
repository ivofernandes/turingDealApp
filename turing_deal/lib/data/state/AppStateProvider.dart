import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/data/api/yahooFinance.dart';
import 'package:turing_deal/data/core/strategy/buyAndHoldStrategy.dart';
import 'package:turing_deal/data/model/strategy.dart';

import 'aux/connectivityState.dart';
import 'aux/navigationState.dart';

class AppStateProvider with ChangeNotifier, ConnectivityState, NavigationState {

  AppStateProvider(BuildContext context){
    //TODO the context is here to get user preferences in the future
  }

  void loadData() async{
    await initConnectivity();
  }


  void refresh() {
    notifyListeners();
  }

}
