import 'package:turing_deal/backTestEngine/core/utils/strategyTime.dart';
import 'package:turing_deal/marketData/core/utils/cleanPrices.dart';
import 'package:turing_deal/marketData/model/candlePrice.dart';
import 'package:turing_deal/marketData/model/stockTicker.dart';
import 'package:turing_deal/marketData/yahooFinance/api/yahooFinance.dart';
import 'package:turing_deal/marketData/yahooFinance/aux/joinPrices.dart';
import 'package:turing_deal/marketData/yahooFinance/storage/yahooFinanceDao.dart';

/// This class abstracts for the state machine how the API vs cache works
class YahooFinanceService{
  /// Gets the candles for a ticker
  static Future<List<CandlePrice>> getTickerData(StockTicker ticker) async {
    List<dynamic>? prices =
    await YahooFinanceDAO().getAllDailyData(ticker.symbol);
    List<CandlePrice> candlePrices = [];

    // If have no cached historical data
    if (prices == null || prices.isEmpty) {
      prices = await getAllDataFromYahooFinance(ticker);
    }

    // If there is offline data but is not up to date
    // try to get the remaining part
    else if(!StrategyTime.isUpToDate(prices)){
      prices = await refreshData(prices, ticker);


    }

    // Clean and format the data
    candlePrices = CleanPrices.clean(prices);

    return candlePrices;
  }

  static Future<List<dynamic>> refreshData(List<dynamic> prices, StockTicker ticker) async{

    if(prices.length > 1) {
      // Get one of the lasts dates in the cache, this is not the more recent,
      // because could have the current price of the request in the close,
      // instead of the real close price
      int lastDate = prices[1]['date'];

      // Get remaing data from yahoo finance
      Map<String, dynamic>? historicalData = await YahooFinance
          .getDailyDataFrom(ticker.symbol, lastDate);

      if (historicalData != null && historicalData['prices'] != null) {
        List<dynamic> nextPrices = historicalData['prices'];

        prices = JoinPrices.joinPrices(prices, nextPrices);

        // Cache data locally
        YahooFinanceDAO().saveDailyData(
            ticker.symbol, historicalData['prices']);
        return prices;
      }
    }

    // If was not possible to refresh, get all data from yahoo finance
    return await getAllDataFromYahooFinance(ticker);
  }

  static Future<List<dynamic>> getAllDataFromYahooFinance(StockTicker ticker) async{

    // Get data from yahoo finance
    Map<String, dynamic>? historicalData =
    await (YahooFinance.getAllDailyData(ticker.symbol));

    if (historicalData != null && historicalData['prices'] != null) {
      List<dynamic> prices = historicalData['prices'];
      // Cache data locally
      YahooFinanceDAO().saveDailyData(ticker.symbol, historicalData['prices']);
      return prices;
    }

    return Future.value([]);
  }
}