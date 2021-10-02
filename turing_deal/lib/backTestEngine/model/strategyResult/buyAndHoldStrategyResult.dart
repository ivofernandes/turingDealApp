import 'dart:collection';

import 'baseStrategyResult.dart';

class BuyAndHoldStrategyResult extends BaseStrategyResult{
  double endPrice = 0;
  Map<int, double> movingAverages = {};
}