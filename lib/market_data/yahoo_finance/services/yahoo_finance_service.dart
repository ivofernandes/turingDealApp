import 'package:turing_deal/back_test_engine/core/utils/strategy_time.dart';
import 'package:turing_deal/market_data/core/utils/clean_prices.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';
import 'package:turing_deal/market_data/yahoo_finance/aux/join_prices.dart';
import 'package:turing_deal/market_data/yahoo_finance/mixer/average_mixer.dart';
import 'package:turing_deal/market_data/yahoo_finance/storage/yahoo_finance_dao.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

/// This class abstracts for the state machine how the API vs cache works
class YahooFinanceService {
  static Future<List<CandlePrice>> getTickerDataList(
      List<String> symbols) async {
    List<List<CandlePrice>> pricesList = [];

    for (String symbol in symbols) {
      List<CandlePrice> prices = await getTickerData(StockTicker(symbol, ''));
      pricesList.add(prices);
    }

    return AverageMixer.mix(pricesList);
  }

  /// Gets the candles for a ticker
  static Future<List<CandlePrice>> getTickerData(StockTicker ticker) async {
    if (ticker.symbol.contains(',')) {
      List<String> symbols = ticker.symbol.split(', ');
      return getTickerDataList(symbols);
    }
    // Try to get data from cache
    List<dynamic>? prices =
        await YahooFinanceDAO().getAllDailyData(ticker.symbol);
    List<CandlePrice> candlePrices = [];

    // If have no cached historical data
    if (prices == null || prices.isEmpty) {
      prices = await getAllDataFromYahooFinance(ticker);
    }

    // If there is offline data but is not up to date
    // try to get the remaining part
    else if (!StrategyTime.isUpToDate(prices)) {
      prices = await refreshData(prices, ticker);
    }

    // Clean and format the data
    candlePrices = CleanPrices.clean(prices);

    return candlePrices;
  }

  static Future<List<dynamic>> refreshData(
      List<dynamic> prices, StockTicker ticker) async {
    if (prices.length > 1) {
      // Get one of the lasts dates in the cache, this is not the more recent,
      // because could have the current price of the request in the close,
      // instead of the real close price
      int lastDate = prices[2]['date'];

      // Get remaing data from yahoo finance
      List<dynamic> nextPrices = await YahooFinanceDailyReader()
          .getDailyData(ticker.symbol, startTimestamp: lastDate);

      if (nextPrices != []) {
        prices = JoinPrices.joinPrices(prices, nextPrices);

        // Cache data after join locally
        YahooFinanceDAO().saveDailyData(ticker.symbol, prices);
        return prices;
      }
    }

    // If was not possible to refresh, get all data from yahoo finance
    return await getAllDataFromYahooFinance(ticker);
  }

  static Future<List<dynamic>> getAllDataFromYahooFinance(
      StockTicker ticker) async {
    // Get data from yahoo finance
    List<dynamic> prices =
        await (YahooFinanceDailyReader().getDailyData(ticker.symbol));

    if (prices != []) {
      // Cache data locally
      YahooFinanceDAO().saveDailyData(ticker.symbol, prices);
      return prices;
    }

    return Future.value([]);
  }
}
