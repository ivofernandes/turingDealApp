// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

void main() {
  test('Test clean prices', () async {
    // Get static data from assets
    const String path = 'test/test_data/yahoo_finance/^GSPC.json';
    final String content = await File(path).readAsString();
    final List<dynamic> jsonList = json.decode(content) as List<dynamic>;

    final List<YahooFinanceCandleData> YahooFinanceCandleDatas = YahooFinanceCandleData.fromJsonList(jsonList);

    assert(YahooFinanceCandleDatas.isNotEmpty);

    final YahooFinanceCandleData lastCandle = YahooFinanceCandleDatas.last;
    assert(lastCandle.volume > 0);
    assert(lastCandle.close > 0);
    assert(lastCandle.high > 0);
    assert(lastCandle.low > 0);
    assert(lastCandle.open > 0);
    assert(lastCandle.high >= lastCandle.low);
  });
}
