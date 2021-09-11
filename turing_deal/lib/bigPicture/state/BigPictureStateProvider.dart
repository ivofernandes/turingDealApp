import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/marketData/core/strategy/buyAndHoldStrategy.dart';
import 'package:turing_deal/marketData/core/strategy/utils/strategyTime.dart';
import 'package:turing_deal/marketData/model/strategy.dart';
import 'package:turing_deal/marketData/model/ticker.dart';
import 'package:turing_deal/marketData/static/TickersList.dart';
import 'package:turing_deal/marketData/yahooFinance/api/yahooFinance.dart';
import 'package:turing_deal/marketData/yahooFinance/storage/yahooFinanceDao.dart';
import 'package:turing_deal/home/state/mixins/connectivityState.dart';

class BigPictureStateProvider with ChangeNotifier, ConnectivityState {

  Map<Ticker, StrategyResult> _bigPictureData = {};

  BigPictureStateProvider(BuildContext context){
    this.loadData(context);
  }

  void loadData(BuildContext context) async{
    await initConnectivity();

    await YahooFinanceDAO().initDatabase();

    List<String> symbols = ['^GSPC','^NDX',
      'XLE','XLF','XLU','XLI','XLV','XLY','XLP','XLB','REET','XLC','FCOM'
    ];

    if(hasInternetConnection()){
      if(_bigPictureData.isEmpty || true) {
        symbols.forEach((symbol) {
          print('adding ticker $symbol');
          Ticker ticker = Ticker(symbol, TickersList.main[symbol]);
          addTicker(ticker, context);
        });
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
    if(prices == null || prices.isEmpty || !StrategyTime.isUpToDate(prices)) {
      // Get data from yahoo finance
      Map<String, dynamic>? historicalData =
          await (YahooFinance.getAllDailyData(ticker.symbol));

      if(historicalData != null && historicalData['prices'] != null){
        prices = historicalData['prices'];
        // Cache data locally
        YahooFinanceDAO().saveDailyData(ticker.symbol, historicalData['prices']);
      }
    }
    return prices;
  }

  Future<void> addTicker(Ticker ticker, BuildContext context) async {
    _bigPictureData[ticker] = StrategyResult();

    try {
      List<dynamic>? prices = await getTickerData(ticker);

      _bigPictureData[ticker]!.progress = 10;
      this.refresh();

      StrategyResult strategy = BuyAndHoldStrategy.buyAndHoldAnalysis(prices!, this);

      _bigPictureData[ticker] = strategy;
      this.refresh();
    }catch (e){
      _bigPictureData.remove(ticker);
      this.refresh();
      throw e;
    }
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
