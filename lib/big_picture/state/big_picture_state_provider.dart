import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:td_ui/td_ui.dart';
import 'package:turing_deal/big_picture/state/big_picture_normalize_period_state.dart';
import 'package:turing_deal/big_picture/state/ticker_utils.dart';
import 'package:turing_deal/home/state/mixins/connectivity_state.dart';

class BigPictureStateProvider with ChangeNotifier, ConnectivityState, BigPictureNormalizePeriodState {
  bool _compactView = false;
  final bool _isMocked = false;
  final Map<StockTicker, BuyAndHoldStrategyResult> _bigPictureData = {};
  String _error = '';

  ScrollController scrollController = ScrollController();

  BigPictureStateProvider() {
    loadData();
  }

  void refresh() {
    notifyListeners();
  }

  String get error => _error;

  bool isCompactView() => _compactView;

  bool isMockedData() => _isMocked;

  void toogleCompactView() {
    _compactView = !_compactView;
    refresh();
  }

  Future<void> loadData() async {
    await initConnectivity();

    await YahooFinanceDAO().initDatabase();
    List<String> symbols = ['^GSPC', '^NDX'];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('symbols') != null) {
      symbols = prefs.getStringList('symbols')!;
    } else {
      await prefs.setStringList('symbols', symbols);
    }
    _error = '';

    if (hasInternetConnection()) {
      if (_bigPictureData.isEmpty || true) {
        for (final String symbol in symbols) {
          try {
            debugPrint('adding ticker $symbol');
            final StockTicker ticker = StockTicker(
              symbol: symbol,
              description: TickersList.main[symbol],
            );
            await addTicker(ticker);

            await Future.delayed(Duration.zero, () {});
          } catch (e) {
            UIUtils.snackBarError('Error adding symbol');
            debugPrint('Error adding ticker $symbol: $e');
          }
        }
        globalAnalysis();
      }
    } else {
      _error = 'Check your internet connection';
      UIUtils.snackBarError(_error);
    }
  }

  Future<void> addTicker(
    StockTicker tickerParam, {
    DateTime? startDate,
  }) async {
    // Treat multiple strategies
    final StockTicker ticker = tickerParam.copyWith(
      symbol: TickerUtils.processSymbol(tickerParam.symbol),
    );

    _bigPictureData[ticker] = BuyAndHoldStrategyResult();

    //  Get data from yahoo finance
    final List<YahooFinanceCandleData> prices = await YahooFinanceService().getTickerData(
      ticker.symbol,
      adjust: true,
      startDate: startDate,
    );

    // Execute the backtest
    final BuyAndHoldStrategyResult strategy = BuyAndHoldStrategy.buyAndHoldAnalysis(prices);

    _bigPictureData[ticker] = strategy;

    resetNormalize();
    refresh();
    if (scrollController.hasClients) {
      // Scroll to the end
      await scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> joinTicker(StockTicker tickerParam, List<StockTicker>? tickers) async {
    if (tickers == null || tickers.isEmpty) {
      return;
    }
    String newSymbol = tickers.first.symbol;
    String oldSymbol = tickerParam.symbol;

    // TODO if the old symbol is weighted, we need to extract the weights and apply them to the new symbol
    if (TickerUtils.isWeightedSymbol(oldSymbol)) {
      final Map<String, double> oldWeights = TickerUtils.extractWeights(oldSymbol);
      final Map<String, double> newWeights = TickerUtils.extractWeights(newSymbol);

      final Map<String, double> combinedWeights = {};

      // Add old weights
      oldWeights.forEach((key, value) {
        combinedWeights[key] = (combinedWeights[key] ?? 0) + value;
      });

      // Add new weights
      newWeights.forEach((key, value) {
        combinedWeights[key] = (combinedWeights[key] ?? 0) + value;
      });

      // Build the new symbol string
      newSymbol = combinedWeights.entries.map((entry) => '${entry.key}-${entry.value}').join(', ');
    }

    final StockTicker ticker = tickerParam.copyWith(
      symbol: '$oldSymbol, $newSymbol',
      description: '',
    );

    final List<YahooFinanceCandleData> prices = await YahooFinanceService().getTickerData(ticker.symbol);

    // Execute the backtest
    final BuyAndHoldStrategyResult strategy = BuyAndHoldStrategy.buyAndHoldAnalysis(prices);

    _bigPictureData[ticker] = strategy;

    refresh();
  }

  Map<StockTicker, BuyAndHoldStrategyResult> getBigPictureData() => _bigPictureData;

  Future<void> removeTicker(StockTicker ticker) async {
    _bigPictureData.remove(ticker);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> symbols = prefs.getStringList('symbols')!;
    symbols.remove(ticker.symbol);
    await prefs.setStringList('symbols', symbols);

    final int deletedRecords = await YahooFinanceDAO().removeDailyData(ticker.symbol);

    refresh();
  }

  void globalAnalysis() {
    // TODO use big picture investing theory to know how the market is performing
    // Comparing each etf with the SP500
    // https://www.fidelity.com/webcontent/ap101883-markets_sectors-content/21.01.0/business_cycle/Business_Cycle_Chart.png
  }

  Future<void> persistTickers() async {
    final List<String> symbols = _bigPictureData.keys.map((StockTicker stockTicker) => stockTicker.symbol).toList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('symbols', symbols);
  }

  Future<void> removeAll() async {
    final List<StockTicker> tickers = _bigPictureData.keys.toList();

    for (final StockTicker ticker in tickers) {
      await removeTicker(ticker);
    }

    refresh();
  }

  Future<void> updateTickerProportion({
    required StockTicker oldTicker,
    required String newSymbol, // e.g. "ES=F-0.5, GC=F-0.5"
    DateTime? startDate,
  }) async {
    // 1) Fully remove the old ticker (map + prefs + DB)
    await removeTicker(oldTicker);

    // 2) Create a new ticker with the updated symbol
    final StockTicker newTicker = oldTicker.copyWith(
      symbol: newSymbol,
      description: oldTicker.description,
    );

    // 3) Reuse the existing addTicker logic to get data + backtest + scroll
    await addTicker(newTicker, startDate: startDate);

    // 4) Persist the new list of tickers (so it survives app restarts)
    await persistTickers();
  }
}
