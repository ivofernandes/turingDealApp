import 'package:flutter_test/flutter_test.dart';
import 'package:turing_deal/back_test_engine/core/utils/calculate_drawdown.dart';
import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';
import 'package:turing_deal/back_test_engine/model/trade/trade.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

void main() {
  test('Test long gain', () async {
    final double percentage =
        CalculateDrawdown.calculatePercentageChange(TradeType.LONG, 10, 20);
    assert(percentage == 100);
  });

  test('Test long loss', () async {
    final double percentage =
        CalculateDrawdown.calculatePercentageChange(TradeType.LONG, 10, 5);
    assert(percentage == -50);
  });

  test('Test short loss', () async {
    final double percentage =
        CalculateDrawdown.calculatePercentageChange(TradeType.SHORT, 10, 20);
    assert(percentage == -50);
  });

  test('Test short gain', () async {
    final double percentage =
        CalculateDrawdown.calculatePercentageChange(TradeType.SHORT, 10, 5);
    assert(percentage == 100);
  });

  test('Test long drawdown in last candle', () async {
    final Trade trade = Trade(
        ticker: 'DUMMY',
        tradeType: TradeType.LONG,
        openPrice: 10,
        openDate: DateTime(2022, 1, 2));
    final TradeOpen tradeOpen = TradeOpen(trade: trade, maxDrawdown: -1);
    final YahooFinanceCandleData lastCandle = YahooFinanceCandleData(
        date: DateTime(2022, 1, 2),
        open: 8,
        high: 9,
        close: 8.5,
        low: 5,
        volume: 100);

    CalculateDrawdown.updateTradeDrawdown(tradeOpen, lastCandle);
    assert(tradeOpen.maxDrawdown == -50);
  });

  test('Test long drawdown in position', () async {
    final Trade trade = Trade(
        ticker: 'DUMMY',
        tradeType: TradeType.LONG,
        openPrice: 10,
        openDate: DateTime(2022, 1, 2));
    final TradeOpen tradeOpen = TradeOpen(trade: trade, maxDrawdown: -60);
    final YahooFinanceCandleData lastCandle = YahooFinanceCandleData(
        date: DateTime(2022, 1, 2),
        open: 8,
        high: 9,
        close: 8.5,
        low: 5,
        volume: 100);

    CalculateDrawdown.updateTradeDrawdown(tradeOpen, lastCandle);
    assert(tradeOpen.maxDrawdown == -60);
  });

  test('Test short drawdown in last candle', () async {
    final Trade trade = Trade(
        ticker: 'DUMMY',
        tradeType: TradeType.SHORT,
        openPrice: 10,
        openDate: DateTime(2022, 1, 2));
    final TradeOpen tradeOpen = TradeOpen(trade: trade, maxDrawdown: -1);
    final YahooFinanceCandleData lastCandle = YahooFinanceCandleData(
        date: DateTime(2022, 1, 2),
        open: 8,
        high: 20,
        close: 8.5,
        low: 5,
        volume: 100);

    CalculateDrawdown.updateTradeDrawdown(tradeOpen, lastCandle);
    assert(tradeOpen.maxDrawdown == -50);
  });

  test('Test short drawdown in position', () async {
    final Trade trade = Trade(
        ticker: 'DUMMY',
        tradeType: TradeType.SHORT,
        openPrice: 10,
        openDate: DateTime(2022, 1, 2));
    final TradeOpen tradeOpen = TradeOpen(trade: trade, maxDrawdown: -60);
    final YahooFinanceCandleData lastCandle = YahooFinanceCandleData(
        date: DateTime(2022, 1, 2),
        open: 8,
        high: 20,
        close: 8.5,
        low: 5,
        volume: 100);

    CalculateDrawdown.updateTradeDrawdown(tradeOpen, lastCandle);
    assert(tradeOpen.maxDrawdown == -60);
  });
}
