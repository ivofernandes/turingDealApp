import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class YahooFinance{

  static int TIMEOUT = 30;
  static String baseUrl = "https://query1.finance.yahoo.com/v7/finance/chart/";

  /// Get daily data for ticker
  /// Url example:
  /// https://query1.finance.yahoo.com/v7/finance/chart/%5EGSPC?range=100y&interval=1d&indicators=quote&includeTimestamps=true
  static Future<Map<String, dynamic>> getDailyData(String ticker) async{
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
}