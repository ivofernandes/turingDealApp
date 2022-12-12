import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:turing_deal/market_data/core/utils/clean_prices.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';
import 'package:turing_deal/shared/my_app_context.dart';

class YahooFinanceMockedData {
  static Future<List<CandlePrice>> getSP500MockedData() async {
    String data = await DefaultAssetBundle.of(MyAppContext.context)
        .loadString("assets/market_data/sp500.json");

    List<dynamic> jsonData = jsonDecode(data);

    return CleanPrices.clean(jsonData);
  }
}
