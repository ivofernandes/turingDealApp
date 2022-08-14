import 'package:flutter_test/flutter_test.dart';
import 'package:turing_deal/back_test_engine/core/utils/calculate_drawdown.dart';
import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';

void main() {
  test('Test long gain', () async {
    double percentage =
        CalculateDrawdown.calculatePercentageChange(TradeType.LONG, 10, 20);
    assert(percentage == 100);
  });

  test('Test long loss', () async {
    double percentage =
        CalculateDrawdown.calculatePercentageChange(TradeType.LONG, 10, 5);
    assert(percentage == -50);
  });

  test('Test short loss', () async {
    double percentage =
        CalculateDrawdown.calculatePercentageChange(TradeType.SHORT, 10, 20);
    assert(percentage == -50);
  });

  test('Test short gain', () async {
    double percentage =
        CalculateDrawdown.calculatePercentageChange(TradeType.SHORT, 10, 5);
    assert(percentage == 100);
  });
}
