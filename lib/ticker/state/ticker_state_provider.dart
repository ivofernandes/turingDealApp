import 'package:flutter/material.dart';
import 'package:turing_deal/market_data/core/indicators/variations.dart';
import 'package:turing_deal/market_data/core/utils/yearly_calculations.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

import '../../market_data/model/yearly_stats.dart';

class TickerStateProvider with ChangeNotifier {
  bool analysisComplete = false;
  bool yearlyStatsComplete = false;
  List<YearlyStats> _yearlyStats = [];
  List<CandlePrice> data = [];

  TickerStateProvider() {
    print('New ticker state provider');
  }

  void startAnalysis(List<CandlePrice> data) {
    this.data = data;
    Future.delayed(Duration.zero, () => analysis());
  }

  bool isAnalysisComplete() {
    return this.analysisComplete;
  }

  List<int> getAvailableVariations() {
    List<int> variations = [];

    for (String key in data.last.indicators.keys) {
      print(key);
    }

    return variations;
  }

  List<CandlePrice> getCandlesData() {
    return this.data;
  }

  analysis() {
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

  List<YearlyStats> getYearlyStats() {
    return _yearlyStats;
  }

  void refresh() {
    notifyListeners();
  }
}
