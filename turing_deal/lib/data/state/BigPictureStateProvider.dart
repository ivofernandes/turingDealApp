import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/data/api/yahooFinance.dart';
import 'package:turing_deal/data/core/strategy/buyAndHoldStrategy.dart';
import 'package:turing_deal/data/model/strategy.dart';
import 'package:turing_deal/data/model/ticker.dart';
import 'package:turing_deal/data/state/shared/connectivityState.dart';
import 'package:turing_deal/data/static/TickersList.dart';

class BigPictureStateProvider with ChangeNotifier, ConnectivityState {

  Map<Ticker, StrategyResult> _bigPictureData = {};

  BigPictureStateProvider(BuildContext context){
    //TODO the context is here to get cached data in the future
    this.loadData();
  }

  void loadData() async{
    await initConnectivity();

    if(hasInternetConnection()){
      if(_bigPictureData.isEmpty || true) {
        Ticker ticker = Ticker('^GSPC', TickersList.main['^GSPC']);
        addTicker(ticker);
      }
    }else{
      //TODO snackbar
      print('Check internet connection');
    }
  }

  void addTicker(Ticker ticker) async{

    _bigPictureData[ticker] = StrategyResult();

    Map<String,dynamic> historicalData = await YahooFinance.getAllDailyData(ticker.symbol);

    _bigPictureData[ticker].loading = 10;
    this.refresh();

    StrategyResult strategy = BuyAndHoldStrategy.buyAndHoldAnalysis(historicalData, this);

    _bigPictureData[ticker] = strategy;
    this.refresh();
  }

  Map<Ticker, dynamic> getBigPictureData() {
    return this._bigPictureData;
  }

  void refresh() {
    notifyListeners();
  }



}
