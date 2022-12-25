import 'package:turing_deal/back_test_engine/model/strategy_result/base_strategy_result.dart';

class BuyAndHoldStrategyResult extends BaseStrategyResult {
  double endPrice = 0;
  Map<int, double> movingAverages = {};
}
