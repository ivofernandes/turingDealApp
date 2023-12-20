import 'package:flutter_test/flutter_test.dart';
import 'package:turing_deal/big_picture/state/ticker_utils.dart';

void main() async {
  test('Test code complexity', () async {
    final Map<String, String> tests = {
      'AAPL MSFT': 'AAPL, MSFT',
      'AAPL, MSFT': 'AAPL, MSFT',
      'VNQ, XLU, XLV, XLY, GC=F, ES=F, NQ=F, SI=F': 'VNQ, XLU, XLV, XLY, GC=F, ES=F, NQ=F, SI=F',
    };

    for (final String input in tests.keys) {
      final String result = TickerUtils.processSymbol(input);
      expect(result, tests[input]);
    }
  });
}
