import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';

class TickerStateProvider with ChangeNotifier {
  bool analysisComplete = false;
  bool yearlyStatsComplete = false;
  List<YearlyStats> _yearlyStats = [];
  List<YahooFinanceCandleData> data = [];

  TickerStateProvider() {
    print('New ticker state provider');
  }

  void startAnalysis(List<YahooFinanceCandleData> data) {
    this.data = data;
    Future.delayed(Duration.zero, analysis);
  }

  bool isAnalysisComplete() => analysisComplete;

  List<int> getAvailableVariations() {
    final List<int> variations = [];

    for (final String key in data.last.indicators.keys) {
      print(key);
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
      analysisComplete = true;

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
