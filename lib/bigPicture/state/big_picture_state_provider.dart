import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/marketData/model/candle_price.dart';
import 'package:turing_deal/backTestEngine/core/buy_and_hold_strategy.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/marketData/model/stock_picker.dart';
import 'package:turing_deal/marketData/static/tickers_list.dart';
import 'package:turing_deal/marketData/yahooFinance/mocked/yahoo_finance_mocked_data.dart';
import 'package:turing_deal/marketData/yahooFinance/services/yahoo_finance_service.dart';
import 'package:turing_deal/marketData/yahooFinance/storage/yahoo_finance_dao.dart';
import 'package:turing_deal/home/state/mixins/connectivity_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turing_deal/shared/ui/UIUtils.dart';

class BigPictureStateProvider with ChangeNotifier, ConnectivityState {
  bool _compactView = false;
  bool _mockedData = false;
  Map<StockTicker, BuyAndHoldStrategyResult> _bigPictureData = {};

  BigPictureStateProvider() {
    this.loadData();
  }

  bool isCompactView(){
    return _compactView;
  }

  bool isMockedData(){
    return _mockedData;
  }

  void toogleCompactView(){
    this._compactView = !this._compactView;
    refresh();
  }

  void loadData() async {
    await initConnectivity();

    await YahooFinanceDAO().initDatabase();
    List<String> symbols = [
      '^GSPC',
      '^NDX'
    ];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getStringList('symbols') != null){
      symbols = prefs.getStringList('symbols')!;
    }else{
      prefs.setStringList('symbols', symbols);
    }

    if (hasInternetConnection()) {
      if (_bigPictureData.isEmpty || true) {
        symbols.forEach((symbol) async {
          print('adding ticker $symbol');
          StockTicker ticker = StockTicker(symbol, TickersList.main[symbol]);
          await addTicker(ticker);
        });
        globalAnalysis();
      }
    } else {
      UIUtils.snackBarError('Check your internet connection');
    }
  }

  Future<void> addTicker(StockTicker ticker) async {
    _bigPictureData[ticker] = BuyAndHoldStrategyResult();

    List<CandlePrice> prices = [];
    try {
      prices = await YahooFinanceService.getTickerData(ticker);
    } catch (e) {
      // If got an http error and is requesting ^GSPC let's step to mocked data
      if(kIsWeb && e.toString() == 'XMLHttpRequest error.' && ticker.symbol == '^GSPC'){
        _mockedData = true;
        prices = await YahooFinanceMockedData.getSP500MockedData();
      }else {
        _bigPictureData.remove(ticker);
        this.refresh();
        throw e;
      }
    }

    _bigPictureData[ticker]!.progress = 10;
    this.refresh();

    BuyAndHoldStrategyResult strategy =
        BuyAndHoldStrategy.buyAndHoldAnalysis(prices);

    _bigPictureData[ticker] = strategy;

    this.refresh();

  }

  Map<StockTicker, BuyAndHoldStrategyResult> getBigPictureData() {
    return this._bigPictureData;
  }

  void refresh() {
    notifyListeners();
  }

  removeTicker(StockTicker ticker) async{
    this._bigPictureData.remove(ticker);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> symbols = prefs.getStringList('symbols')!;
    symbols.remove(ticker.symbol);
    prefs.setStringList('symbols',symbols);

    this.refresh();
  }

  void globalAnalysis() {
    // TODO use big picture investing theory to know how the market is performing
    // Comparing each etf with the SP500
    // https://www.fidelity.com/webcontent/ap101883-markets_sectors-content/21.01.0/business_cycle/Business_Cycle_Chart.png
  }

  void persistAddTicker(StockTicker ticker) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> symbols = prefs.getStringList('symbols')!;
    symbols.add(ticker.symbol);
    prefs.setStringList('symbols',symbols);
  }
}
