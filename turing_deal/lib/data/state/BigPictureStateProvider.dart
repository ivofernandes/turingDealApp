import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/data/api/yahooFinance.dart';
import 'package:turing_deal/data/core/strategy/buyAndHoldStrategy.dart';
import 'package:turing_deal/data/model/strategy.dart';
import 'package:turing_deal/data/state/aux/loadingState.dart';

import 'aux/connectivityState.dart';

class BigPictureStateProvider with ChangeNotifier, ConnectivityState, LoadingState {

  Map<String, Strategy> _bigPictureData = {};

  BigPictureStateProvider(BuildContext context){
    //TODO the context is here to get cached data in the future
    this.loadData();
  }

  void loadData() async{
    await initConnectivity();

    if(hasInternetConnection()){
      if(_bigPictureData.isEmpty || true) {
        String ticker = '^GSPC';
        this.setLoadingState(LoadingState.STATE_DOWNLOADING);
        this.notifyListeners();

        Map<String,dynamic> historicalData = await YahooFinance.getAllDailyData(ticker);
        this.setLoadingState(LoadingState.STATE_PROCESSING);
        this.notifyListeners();

        Strategy strategy = BuyAndHoldStrategy.buyAndHoldAnalysis(historicalData, this);

        this.setLoadingState(LoadingState.STATE_DONE);
        _bigPictureData[ticker] = strategy;
        this.notifyListeners();
      }
    }else{
      //TODO snackbar
      print('Check internet connection');
    }
  }

  Map<String, dynamic> getBigPictureData() {
    return this._bigPictureData;
  }

  void refresh() {
    notifyListeners();
  }


}
