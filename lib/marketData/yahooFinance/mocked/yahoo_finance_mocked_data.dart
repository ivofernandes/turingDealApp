
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turing_deal/marketData/core/utils/clean_prices.dart';
import 'package:turing_deal/marketData/model/candle_price.dart';

class YahooFinanceMockedData {
  static Future<List<CandlePrice>> getSP500MockedData() async{

    String data = await DefaultAssetBundle.of(Get.context!).loadString("assets/marketData/sp500.json");

    List<dynamic> jsonData = jsonDecode(data);

    return CleanPrices.clean(jsonData);
  }
}