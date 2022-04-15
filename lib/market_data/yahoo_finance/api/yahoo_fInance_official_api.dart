import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:turing_deal/market_data/model/stock_ticker.dart';

class YahooFinanceOfficialAPI {
  static const int TIMEOUT = 30;

  /// Get daily data for ticker
  /// Url example:
  /// https://query1.finance.yahoo.com/v7/finance/chart/%5EGSPC?range=100y&interval=1d&indicators=quote&includeTimestamps=true
  /// https://query1.finance.yahoo.com/v7/finance/chart/%5EGSPC/?range=100y&interval=1d&indicators=quote&includeTimestamps=true
  static Future<Map<String, dynamic>> getDailyData(StockTicker ticker) async {
    Uri uri = Uri.https(
        'query1.finance.yahoo.com', 'v7/finance/chart/' + ticker.symbol, {
      'range': '100y',
      'interval': '1d',
      'indicators': 'quote',
      'includeTimestamps': 'true'
    });

    http.Response response =
        await http.get(uri).timeout(Duration(seconds: TIMEOUT), onTimeout: () {
      throw TimeoutException('Timeout');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return json;
    } else {
      return Future.value({});
    }
  }
}
