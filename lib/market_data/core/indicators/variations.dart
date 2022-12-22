import 'package:turing_deal/market_data/model/variation/variation_count.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class Variations {
  /// Base method to get intervals from the chart
  static List<VariationCount> countByInterval(
      double lowerLimit,
      double upperLimit,
      double step,
      List<YahooFinanceCandleData> data,
      int delta) {
    Map<String, List<double?>> intervals =
        getIntervals(lowerLimit, upperLimit, step);
    return countVariationsInIntervals(intervals, data, delta);
  }

  static Map<String, List<double?>> getIntervals(
      double lowerLimit, double upperLimit, double interval) {
    Map<String, List<double?>> intervals = {
      '<$lowerLimit%': [null, lowerLimit]
    };

    for (double lowerValue = lowerLimit;
        lowerValue < upperLimit;
        lowerValue += interval) {
      double upperValue = lowerValue + interval;

      intervals[
          '${lowerValue.toStringAsFixed(0)}% .. ${upperValue.toStringAsFixed(0)}%'] = [
        lowerValue,
        upperValue
      ];
    }

    intervals['>$upperLimit%'] = [upperLimit, null];
    return intervals;
  }

  static List<VariationCount> countVariationsInIntervals(
      Map<String, List<double?>> intervals,
      List<YahooFinanceCandleData> data,
      int delta) {
    List<VariationCount> result = [];

    for (String intervalDescription in intervals.keys) {
      List<double?> interval = intervals[intervalDescription]!;

      int count =
          Variations.countVariations(interval[0], interval[1], data, delta);

      result.add(VariationCount(intervalDescription, count));
    }

    return result;
  }

  ///
  static void calculateVariations(
      List<YahooFinanceCandleData> prices, int delta) {
    for (int i = 0; i < prices.length - delta; i++) {
      double variation = (prices[i + delta].close / prices[i].close - 1) * 100;

      prices[i].indicators['var_$delta'] = variation;
    }
  }

  static int countVariations(double? lowerLimit, double? upperLimit,
      List<YahooFinanceCandleData> data, int delta) {
    int count = data
        .where((YahooFinanceCandleData candle) =>
            candle.indicators.containsKey('var_$delta') &&
            validLowerLimit(lowerLimit, candle.indicators['var_$delta']!) &&
            validUpperLimit(upperLimit, candle.indicators['var_$delta']!))
        .length;

    return count;
  }

  static bool validLowerLimit(double? lowerLimit, double value) {
    return lowerLimit == null || value >= lowerLimit;
  }

  static bool validUpperLimit(double? upperLimit, double value) {
    return upperLimit == null || value < upperLimit;
  }

  static List<double> extractList(
      List<YahooFinanceCandleData> data, int delta) {
    List<double?> vars = data
        .map((YahooFinanceCandleData e) => e.indicators['var_$delta'])
        .toList();

    vars.removeWhere((element) => element == null);
    List<double> v = vars.cast();

    return v;
  }
}
