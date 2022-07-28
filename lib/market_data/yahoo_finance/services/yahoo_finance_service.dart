import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:turing_deal/back_test_engine/core/utils/strategy_time.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/market_data/core/utils/clean_prices.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';
import 'package:turing_deal/market_data/yahoo_finance/aux/join_prices.dart';
import 'package:turing_deal/market_data/yahoo_finance/mixer/average_mixer.dart';
import 'package:turing_deal/market_data/yahoo_finance/storage/yahoo_finance_dao.dart';

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
      // Get one of the lasts dates in the cache, this is not the most recent,
      // because the most recent often is in the middle of the day,
      // and the yahoo finance returns us the current price in the close price column,
      // and for joining dates, we need real instead of the real close prices
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
    List<dynamic> prices = [];

    // Get data from yahoo finance
    try {
      prices = await YahooFinanceDailyReader().getDailyData(ticker.symbol);
    } catch (e) {
      if (AppStateProvider.isDesktopWeb() &&
          e.toString().contains('XMLHttpRequest error.')) {
        prices = await YahooFinanceDailyReader(
                prefix: 'https://thingproxy.freeboard.io/fetch/https://')
            .getDailyData(ticker.symbol);
      }
    }

    if (prices != []) {
      // Cache data locally
      YahooFinanceDAO().saveDailyData(ticker.symbol, prices);
      return prices;
    }

    return Future.value([]);
  }
}

class YahooFinanceDailyReader {
  final Duration timeout;
  final String prefix;
  final Map<String, dynamic>? headers;

  const YahooFinanceDailyReader(
      {this.timeout = const Duration(seconds: 30),
      this.prefix = 'https://',
      this.headers});

  /// Python like get allDailyData, inspired on pandas_datareader/yahoo/daily
  /// Steps:
  /// 1 - // Get https://finance.yahoo.com/quote/%5EGSPC/history?period1=-1577908800&period2=1617505199&interval=1d&indicators=quote&includeTimestamps=true
  /// 2 - Find the delimiters of the begging and end of the json
  /// 3 - Get item ["context"]["dispatcher"]["stores"]["HistoricalPriceStore"]
  Future<List<dynamic>> getDailyData(String ticker,
      {int startTimestamp = -1577908800}) async {
    ticker = ticker.toUpperCase();
    String now =
        (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();

    String url = '${prefix}finance.yahoo.com/quote/$ticker/history?'
        'period1=$startTimestamp&period2=$now&interval=1d&indicators=quote&includeTimes';

    Dio dio = Dio();
    dio.options.connectTimeout = timeout.inMilliseconds;
    dio.options.receiveTimeout = timeout.inMilliseconds;

    Map<String, dynamic> currentHeaders = {
      'content-type': 'application/json',
      'charset': 'utf-8',
      'Access-Control-Allow-Origin': '*'
    };

    if (headers != null) {
      currentHeaders = headers!;
    }

    dio.options.headers = currentHeaders;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      String body = response.toString();

      return await computeResponse(body);
    }

    // If was not a 200 status code, return empty list
    return [];
  }

  Future<List<dynamic>> computeResponse(String value) {
    return compute(processResponse, value);
  }

  List<dynamic> processResponse(String body) {
    // Find the json in the html
    String startDelimiter = 'root.App.main = ';
    String endDelimiter = ';\n}(this));';

    int startIndex = body.indexOf(startDelimiter) + startDelimiter.length;
    int endIndex = body.indexOf(endDelimiter, startIndex);
    String jsonString = body.substring(startIndex, endIndex);

    // Parse all json
    Map<String, dynamic> json = jsonDecode(jsonString);

    // Get item ["context"]["dispatcher"]["stores"]["HistoricalPriceStore"]
    Map<String, dynamic>? historicalPrice =
        json["context"]["dispatcher"]["stores"]["HistoricalPriceStore"];

    List<dynamic> result = [];

    if (historicalPrice != null) {
      result = historicalPrice["prices"];
    }

    return result;
  }
}
