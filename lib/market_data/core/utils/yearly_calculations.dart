import 'package:turing_deal/back_test_engine/core/utils/calculate_drawdown.dart';
import 'package:turing_deal/back_test_engine/core/utils/calculate_strategy_metrics.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_drawdown.dart';
import 'package:turing_deal/market_data/model/yearly_stats.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class YearlyCalculations {
  static List<YearlyStats> calculate(List<YahooFinanceCandleData> data) {
    final List<YearlyStats> result = [];

    if (data.isNotEmpty) {
      int currentYear = data.first.date.year;
      List<YahooFinanceCandleData> candlesOfTheYear = [];

      for (final YahooFinanceCandleData candle in data) {
        if (candle.date.year == currentYear) {
          candlesOfTheYear.add(candle);
        } else {
          addToResult(result, currentYear, candlesOfTheYear);

          currentYear = candle.date.year;
          candlesOfTheYear = [];
        }
      }

      addToResult(result, currentYear, candlesOfTheYear);
    }
    return result;
  }

  static void addToResult(List<YearlyStats> result, int currentYear,
      List<YahooFinanceCandleData> candlesOfTheYear) {
    // To have variation needs two days at least
    if (candlesOfTheYear.length > 1) {
      final StrategyDrawdown strategyDrawdown =
          CalculateDrawdown.calculateStrategyDrawdown(candlesOfTheYear);
      final double drawdown = strategyDrawdown.maxDrawdown;

      final double cagr = CalculateStrategyMetrics.calculateCAGR(candlesOfTheYear);

      result.add(
          YearlyStats(year: currentYear, variation: cagr, drawdown: drawdown));
    }
  }
}
