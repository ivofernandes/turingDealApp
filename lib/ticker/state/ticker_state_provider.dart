import 'package:flutter/material.dart';
import 'package:turing_deal/market_data/core/indicators/variations.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

class TickerStateProvider with ChangeNotifier {
  bool analysisComplete = false;

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

  void refresh() {
    notifyListeners();
  }

  analysis() {
    if (!analysisComplete) {
      Variations.calculateVariations(data, 1);
      Variations.calculateVariations(data, 5);
      Variations.calculateVariations(data, 20);

      analysisComplete = true;

      refresh();
    }
  }
}
