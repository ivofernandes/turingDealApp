import 'package:flutter_test/flutter_test.dart';
import 'package:turing_deal/back_test_engine/core/buy_and_hold_strategy.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

void main() {
  test('Test buy and hold strategy_result', () async {
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
