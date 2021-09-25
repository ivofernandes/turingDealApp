// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:turing_deal/marketData/core/utils/cleanPrices.dart';
import 'package:turing_deal/marketData/model/candlePrice.dart';

void main() {
  test('Test clean prices', () async {
    // Get static data from assets
    String path = 'assets/marketData/yahooFinance/^GSPC.json';
    String content = await File(path).readAsString();
    List<dynamic> jsonObject = json.decode(content);

    List<CandlePrice> candlePrices = CleanPrices.clean(jsonObject);

    assert(candlePrices.isNotEmpty);

    CandlePrice lastCandle = candlePrices.last;
    assert(lastCandle.volume > 0);
    assert(lastCandle.close > 0);
    assert(lastCandle.high > 0);
    assert(lastCandle.low > 0);
    assert(lastCandle.open > 0);
    assert(lastCandle.high >= lastCandle.low);
  });
}
