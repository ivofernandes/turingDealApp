
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/data/api/yahooFinance.dart';
import 'package:turing_deal/data/core/strategy/buyAndHoldStrategy.dart';
import 'package:turing_deal/data/model/strategy.dart';
import 'package:turing_deal/data/model/ticker.dart';
import 'package:turing_deal/data/state/shared/connectivityState.dart';
import 'package:turing_deal/data/static/TickersList.dart';
import 'package:turing_deal/data/storage/yahooFinanceDao.dart';

class BigPictureStateProvider with ChangeNotifier, ConnectivityState {

  Map<Ticker, StrategyResult> _bigPictureData = {};

  BigPictureStateProvider(BuildContext context){
    this.loadData(context);
  }

  void loadData(BuildContext context) async{
    await initConnectivity();

    await YahooFinanceDAO().initDatabase();

    String symbol = '^GSPC';

    if(hasInternetConnection()){
      if(_bigPictureData.isEmpty || true) {
        Ticker ticker = Ticker(symbol, TickersList.main[symbol]);
        addTicker(ticker, context);
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text( 'Check your internet connection',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).errorColor
            ),
          )
      ));
    }
  }

  Future<List<dynamic>?> getTickerData(ticker) async{
    List<dynamic>? prices = await YahooFinanceDAO().getAllDailyData(ticker.symbol);

    // If have no cached historical data
    if(prices == null || prices.isEmpty || BuyAndHoldStrategy.isUpToDate(prices)) {
      // Get data from yahoo finance
      Map<String, dynamic>? historicalData =
          await (YahooFinance.getAllDailyData(ticker.symbol));

      if(historicalData != null && historicalData['prices'] != null){
        // Cache data locally
        YahooFinanceDAO().saveDailyData(ticker.symbol, historicalData['prices']);
      }
    }
    return prices;
  }

  void addTicker(Ticker ticker, BuildContext context) async {
    _bigPictureData[ticker] = StrategyResult();

    List<dynamic>? prices = await getTickerData(ticker);

    _bigPictureData[ticker]!.progress = 10;
    this.refresh();

    StrategyResult strategy =
        BuyAndHoldStrategy.buyAndHoldAnalysis(prices!, this);

    _bigPictureData[ticker] = strategy;
    this.refresh();
  }

  Map<Ticker, StrategyResult> getBigPictureData() {
    return this._bigPictureData;
  }

  void refresh() {
    notifyListeners();
  }

  removeTicker(Ticker ticker) {
    this._bigPictureData.remove(ticker);
    this.refresh();
  }
}
