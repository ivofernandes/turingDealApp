// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:turing_deal/market_data/core/utils/calculate_indicators.dart';
import 'package:turing_deal/market_data/core/utils/clean_prices.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

void main() {

  test('Test calculate indicators', () async {

    print(DateTime.now().toString() + ' > getting an sp500 dataframe');
    // Get static data from assets
    String path = 'test/test_data/yahoo_finance/^GSPC.json';
    String content = await File(path).readAsString();
    List<dynamic> jsonObject = json.decode(content);

    List<CandlePrice> candlePrices = CleanPrices.clean(jsonObject);

    print(DateTime.now().toString() + ' > calculating indicators');
    assert(candlePrices.isNotEmpty);

    // TODO Check if it can deal with invalid data,
    //  will need to raise an exception so the user can receive and UI indicator that something is wrong
    //
    // CalculateIndicators.calculateIndicators(candlePrices, ['invalid_indicator', 'strangeStuff']);

    // Check if with data that is okay can perform a calculation
    CalculateIndicators.calculateIndicators(candlePrices, ['SMA_50','SMA_20']);

    assert(candlePrices[100].indicators.isNotEmpty);

    print(DateTime.now().toString() + ' > calculated indicators');
  });
}
