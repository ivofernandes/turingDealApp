import 'package:turing_deal/back_test_engine/core/utils/calculate_drawdown.dart';
import 'package:turing_deal/back_test_engine/core/utils/calculate_strategy_metrics.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_drawdown.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';
import 'package:turing_deal/market_data/model/yearly_stats.dart';

class YearlyCalculations {
  static List<YearlyStats> calculate(List<CandlePrice> data) {
    List<YearlyStats> result = [];

    if (data.isNotEmpty) {
      int currentYear = data.first.date.year;
      List<CandlePrice> candlesOfTheYear = [];

      for (CandlePrice candle in data) {
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
      List<CandlePrice> candlesOfTheYear) {
    // To have variation needs two days at least
    if (candlesOfTheYear.length > 1) {
      StrategyDrawdown strategyDrawdown =
          CalculateDrawdown.calculateStrategyDrawdown(candlesOfTheYear);
      double drawdown = strategyDrawdown.maxDrawdown;

      double CAGR = CalculateStrategyMetrics.calculateCAGR(candlesOfTheYear);

      result.add(
          YearlyStats(year: currentYear, variation: CAGR, drawdown: drawdown));
    }
  }
}
