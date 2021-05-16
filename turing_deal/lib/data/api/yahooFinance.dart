import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class YahooFinance{

  static int TIMEOUT = 30;

  /// Get daily data for ticker using API
  /// Url example:
  /// https://query1.finance.yahoo.com/v7/finance/chart/%5EGSPC?range=100y&interval=1d&indicators=quote&includeTimestamps=true
  static Future<Map<String, dynamic>> getDailyData(String ticker) async{

    String baseUrl = "https://query1.finance.yahoo.com/v7/finance/chart/";
    String options = "range=max&interval=1d&indicators=quote&includeTimestamps=true";
    String url = baseUrl + ticker + "?" +options;

    http.Response response = await http.get(url).timeout(Duration(seconds: TIMEOUT),
        onTimeout: () {
      throw TimeoutException('Timeout');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return json;
    }else {
      return null;
    }
  }

  /// Python like get allDailyData, inspired on pandas_datareader/yahoo/daily
  /// Steps:
  /// 1 - // Get https://finance.yahoo.com/quote/%5EGSPC/history?period1=-1577908800&period2=1617505199&interval=1d&indicators=quote&includeTimestamps=true
  /// 2 - Find the delimiters of the begging and end of the json
  /// 3 - Get item ["context"]["dispatcher"]["stores"]["HistoricalPriceStore"]
  static Future<Map<String,dynamic>> getAllDailyData(String ticker) async{

    String now = DateTime.now().millisecondsSinceEpoch.toString();
    String url = 'https://finance.yahoo.com/quote/' + ticker + '/history'
        '?period1=-1577908800&period2=' + now + '&interval=1d&indicators=quote&includeTimestamps=true';

    http.Response response = await http.get(url).timeout(Duration(seconds: TIMEOUT),
        onTimeout: () {
          throw TimeoutException('Timeout');
        });

    if (response.statusCode == 200) {
      String body = response.body;

      // Find the json in the html
      String startDelimiter = 'root.App.main = ';
      String endDelimiter = ';\n}(this));';

      int startIndex = body.indexOf(startDelimiter) + startDelimiter.length;
      int endIndex = body.indexOf(endDelimiter);
      String jsonString = body.substring(startIndex, endIndex);

      // Parse all json
      Map<String, dynamic> json = jsonDecode(jsonString);

      // Get item ["context"]["dispatcher"]["stores"]["HistoricalPriceStore"]
      Map<String, dynamic> historicalPrice = json["context"]["dispatcher"]["stores"]["HistoricalPriceStore"];

      return historicalPrice;
    }else {
      return null;
    }
  }
}