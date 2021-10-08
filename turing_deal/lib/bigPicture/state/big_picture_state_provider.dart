import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/marketData/core/utils/clean_prices.dart';
import 'package:turing_deal/marketData/model/candle_price.dart';
import 'package:turing_deal/backTestEngine/core/buy_and_hold_strategy.dart';
import 'package:turing_deal/backTestEngine/core/utils/strategy_time.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/marketData/model/stock_picker.dart';
import 'package:turing_deal/marketData/static/tickers_list.dart';
import 'package:turing_deal/marketData/yahooFinance/api/yahoo_finance.dart';
import 'package:turing_deal/marketData/yahooFinance/services/yahoo_finance_service.dart';
import 'package:turing_deal/marketData/yahooFinance/storage/yahoo_finance_dao.dart';
import 'package:turing_deal/home/state/mixins/connectivity_state.dart';

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

  Future<void> addTicker(StockTicker ticker, BuildContext context) async {
    _bigPictureData[ticker] = BuyAndHoldStrategyResult();

    try {
      List<CandlePrice> prices = await YahooFinanceService.getTickerData(ticker);

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
