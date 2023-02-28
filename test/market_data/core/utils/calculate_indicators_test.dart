// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stock_market_data/stock_market_data.dart';

void main() {
  test('Test calculate indicators', () async {
    print('${DateTime.now()} > getting an sp500 dataframe');
    // Get static data from assets
    const String path = 'test/test_data/yahoo_finance/^GSPC.json';
    final String content = await File(path).readAsString();
    final List<dynamic> jsonObject = json.decode(content) as List<dynamic>;

    final List<YahooFinanceCandleData> YahooFinanceCandleDatas = YahooFinanceCandleData.fromJsonList(jsonObject);

    print('${DateTime.now()} > calculating indicators');
    assert(YahooFinanceCandleDatas.isNotEmpty);

    // TODO Check if it can deal with invalid data,
    //  will need to raise an exception so the user can receive and UI indicator that something is wrong
    //
    // CalculateIndicators.calculateIndicators(YahooFinanceCandleDatas, ['invalid_indicator', 'strangeStuff']);

    // Check if with data that is okay can perform a calculation
    CalculateIndicators.calculateIndicators(YahooFinanceCandleDatas, ['SMA_20']);
    assert(YahooFinanceCandleDatas[100].indicators.isNotEmpty);

    print('${DateTime.now()} > calculated indicators');
  });
}
