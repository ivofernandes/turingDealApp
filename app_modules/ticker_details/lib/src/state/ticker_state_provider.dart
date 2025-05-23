import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';

/// This class is responsible for holding the state of the ticker details page
class TickerStateProvider with ChangeNotifier {
  /// Is the analysis complete?
  bool get analysisComplete => data.isNotEmpty && data.first.indicators.containsKey('var_1');

  /// Are the yearly stats complete?
  bool yearlyStatsComplete = false;

  /// The yearly stats
  List<YearlyStats> _yearlyStats = [];

  /// The candles data
  List<YahooFinanceCandleData> data = [];

  TickerStateProvider() {
    debugPrint('New ticker state provider');
  }

  void startAnalysis(List<YahooFinanceCandleData> data) {
    this.data = data;
    Future.delayed(Duration.zero, analysis);
  }

  bool isAnalysisComplete() => analysisComplete;

  List<int> getAvailableVariations() {
    final List<int> variations = [];

    for (final String key in data.last.indicators.keys) {
      debugPrint(key);
    }

    return variations;
  }

  List<YahooFinanceCandleData> getCandlesData() => data;

  void analysis() {
    if (!yearlyStatsComplete) {
      _yearlyStats = YearlyCalculations.calculate(data);

      yearlyStatsComplete = true;
      refresh();
    }

    if (!analysisComplete) {
      Future.delayed(Duration.zero, () {
        Variations.calculateVariations(data, 1);
        Variations.calculateVariations(data, 5);
        Variations.calculateVariations(data, 20);

        refresh();
      });
    }
  }

  List<YearlyStats> getYearlyStats() => _yearlyStats;

  void refresh() {
    notifyListeners();
  }
}
