import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/marketData/core/utils/cleanPrices.dart';
import 'package:turing_deal/marketData/model/candlePrice.dart';
import 'package:turing_deal/strategyEngine/core/buyAndHoldStrategy.dart';
import 'package:turing_deal/strategyEngine/core/utils/strategyTime.dart';
import 'package:turing_deal/strategyEngine/model/strategy/buyAndHoldStrategyResult.dart';
import 'package:turing_deal/marketData/model/stockTicker.dart';
import 'package:turing_deal/marketData/static/TickersList.dart';
import 'package:turing_deal/marketData/yahooFinance/api/yahooFinance.dart';
import 'package:turing_deal/marketData/yahooFinance/storage/yahooFinanceDao.dart';
import 'package:turing_deal/home/state/mixins/connectivityState.dart';

class BigPictureStateProvider with ChangeNotifier, ConnectivityState {
  bool _compactView = false;
  Map<StockTicker, BuyAndHoldStrategyResult> _bigPictureData = {};

  BigPictureStateProvider(BuildContext context) {
    this.loadData(context);
  }

  bool isCompactView(){
    return _compactView;
  }

  void toogleCompactView(){
    this._compactView = !this._compactView;
    refresh();
  }

  void loadData(BuildContext context) async {
    await initConnectivity();

    await YahooFinanceDAO().initDatabase();

    List<String> symbols = [
      '^GSPC',
      '^NDX',
      'XLE',
      'XLF',
      'XLU',
      'XLI',
      'XLV',
      'XLY',
      'XLP',
      'XLB',
      'REET',
      'XLC',
      'FCOM'
    ];

    if (hasInternetConnection()) {
      if (_bigPictureData.isEmpty || true) {
        symbols.forEach((symbol) async {
          print('adding ticker $symbol');
          StockTicker ticker = StockTicker(symbol, TickersList.main[symbol]);
          await addTicker(ticker, context);
        });
        globalAnalysis();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'Check your internet connection',
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Theme.of(context).errorColor),
      )));
    }
  }

  Future<List<CandlePrice>> getTickerData(ticker) async {
    List<dynamic>? prices =
        await YahooFinanceDAO().getAllDailyData(ticker.symbol);
    List<CandlePrice> candlePrices = [];

    // If have no cached historical data
    if (prices == null || prices.isEmpty || !StrategyTime.isUpToDate(prices)) {
      // Get data from yahoo finance
      Map<String, dynamic>? historicalData =
          await (YahooFinance.getAllDailyData(ticker.symbol));

      if (historicalData != null && historicalData['prices'] != null) {
        prices = historicalData['prices'];
        // Cache data locally
        YahooFinanceDAO()
            .saveDailyData(ticker.symbol, historicalData['prices']);
      }
    }
    // Clean and format the data
    if(prices != null){
      candlePrices = CleanPrices.clean(prices);
    }

    return candlePrices;
  }

  Future<void> addTicker(StockTicker ticker, BuildContext context) async {
    _bigPictureData[ticker] = BuyAndHoldStrategyResult();

    try {
      List<CandlePrice> prices = await getTickerData(ticker);

      _bigPictureData[ticker]!.progress = 10;
      this.refresh();

      BuyAndHoldStrategyResult strategy =
          BuyAndHoldStrategy.buyAndHoldAnalysis(prices);

      _bigPictureData[ticker] = strategy;
      this.refresh();
    } catch (e) {
      _bigPictureData.remove(ticker);
      this.refresh();
      throw e;
    }
  }

  Map<StockTicker, BuyAndHoldStrategyResult> getBigPictureData() {
    return this._bigPictureData;
  }

  void refresh() {
    notifyListeners();
  }

  removeTicker(StockTicker ticker) {
    this._bigPictureData.remove(ticker);
    this.refresh();
  }

  void globalAnalysis() {
    // TODO use big picture investing theory to know how the market is performing
    // Comparing each etf with the SP500
    // https://www.fidelity.com/webcontent/ap101883-markets_sectors-content/21.01.0/business_cycle/Business_Cycle_Chart.png
  }
}
