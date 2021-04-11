import 'package:turing_deal/data/model/strategy.dart';
import 'package:turing_deal/data/state/BigPictureStateProvider.dart';

class BuyAndHoldStrategy{

  /// Simulate a buy and hold strategy
  static Strategy buyAndHoldAnalysis(Map<String,dynamic> historicalPrices, BigPictureStateProvider bigPictureStateProvider){

    List prices = historicalPrices['prices'];

    Strategy strategy = Strategy();
    strategy.valid = false;

    if(prices.isNotEmpty) {
      strategy.CAGR = 1;
      strategy.drawdown = 1;
      strategy.MAR = 1;

      strategy.valid = true;
    }

    return strategy;
  }

}