// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:turing_deal/market_data/core/indicators/sma.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

void main() {
  test('Test SMA_2', () async {
    final List<YahooFinanceCandleData> prices = [
      YahooFinanceCandleData(
          date: DateTime(2019),
          volume: 1,
          open: 1,
          close: 0,
          high: 1,
          low: 0),
      YahooFinanceCandleData(
          date: DateTime(2019, 3),
          volume: 1,
          open: 1,
          close: 0.5,
          high: 1,
          low: 0.5),
      YahooFinanceCandleData(
          date: DateTime(2019, 6),
          volume: 1,
          open: 1,
          close: 0.5,
          high: 2,
          low: 1.5),
      YahooFinanceCandleData(
          date: DateTime(2019, 12, 31),
          volume: 1,
          open: 2,
          close: 1,
          high: 2,
          low: 2),
      YahooFinanceCandleData(
          date: DateTime(2020),
          volume: 1,
          open: 1,
          close: 1,
          high: 1,
          low: 1),
      YahooFinanceCandleData(
          date: DateTime(2020, 3),
          volume: 1,
          open: 1,
          close: 1,
          high: 1,
          low: 0.5),
      YahooFinanceCandleData(
          date: DateTime(2020, 6),
          volume: 1,
          open: 1,
          close: 1,
          high: 2,
          low: 1.5),
      YahooFinanceCandleData(
          date: DateTime(2020, 12, 31),
          volume: 1,
          open: 2,
          close: 2,
          high: 2,
          low: 2),
    ];

    SMA.calculateSMA(prices, 2);

    assert(prices[0].indicators.isEmpty);

    for (int i = 1; i < prices.length; i++) {
      assert(prices[i].indicators.isNotEmpty);
    }

    assert(prices[1].indicators['SMA_2'] == 0.25);
    assert(prices[2].indicators['SMA_2'] == 0.5);
    assert(prices[3].indicators['SMA_2'] == 0.75);
    assert(prices[4].indicators['SMA_2'] == 1);
    assert(prices[5].indicators['SMA_2'] == 1);
    assert(prices[6].indicators['SMA_2'] == 1);
    assert(prices[7].indicators['SMA_2'] == 1.5);
  });
}
