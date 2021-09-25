// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:turing_deal/main.dart';
import 'package:turing_deal/marketData/model/candlePrice.dart';
import 'package:turing_deal/strategyEngine/model/strategy/buyAndHoldStrategyResult.dart';
import 'package:turing_deal/strategyEngine/core/buyAndHoldStrategy.dart';

void main() {
  test('Test buy and hold strategy', () async {
    List<CandlePrice> prices = [
      CandlePrice(date: DateTime(2020, 1, 1), volume: 1, open: 1, close: 1, high: 1, low: 1),
      CandlePrice(date: DateTime(2020, 3, 1), volume: 1, open: 1, close: 1, high: 1, low: 0.5),
      CandlePrice(date: DateTime(2020, 6, 1), volume: 1, open: 1, close: 1, high: 2, low: 1.5),
      CandlePrice(date: DateTime(2020, 12, 31), volume: 1, open: 2, close: 2, high: 2, low: 2),
    ];

    BuyAndHoldStrategyResult strategy = BuyAndHoldStrategy.buyAndHoldAnalysis(prices);

    assert(strategy.CAGR == 100);
    assert(strategy.drawdown == -50);
    assert(strategy.MAR == 2);
    assert(strategy.tradingYears == 1);

    print(strategy.toString());
  });
}
