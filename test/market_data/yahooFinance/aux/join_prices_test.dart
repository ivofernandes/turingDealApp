// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:turing_deal/market_data/yahoo_finance/aux/join_prices.dart';

import 'join_prices_text_aux.dart';

void main() {
  test('Join prices test', () async {
    List<Map<String, dynamic>> oldPricesList = [
      {"date": 1633354200, "adjclose": 53.13999938964844},
      {"date": 1633095000, "adjclose": 54.310001373291016},
      {"date": 1632922200, "adjclose": 53.470001220703125}
    ];

    List<Map<String, dynamic>> recentPricesList = [
      {"date": 1633464000, "adjclose": 53.91999816894531},
      {"date": 1633354200, "adjclose": 53.13999938964844},
      {"date": 1633095000, "adjclose": 54.310001373291016}
    ];

    JoinPricesTextAux.addTimestampForTesting(recentPricesList);
    JoinPricesTextAux.addTimestampForTesting(oldPricesList);

    List<dynamic> result =
        JoinPrices.joinPrices(oldPricesList, recentPricesList);

    JoinPricesTextAux.validateSizeAndContinuity(result, 4);
  });

  test('Join prices test split 1/2', () async {
    List<Map<String, dynamic>> oldPricesList = [
      {
        // 2021-10-04 14:30:00.000
        "date": 1633354200, // Will be splited
        "adjclose": 4
      },
      {
        // 2021-10-01 14:30:00.000
        "date": 1633095000, "adjclose": 3
      },
      {
        // 2021-09-29 14:30:00.000
        "date": 1632922200, "adjclose": 1
      }
    ];

    List<Map<String, dynamic>> recentPricesList = [
      {
        // 2021-10-05 21:00:00.000
        "date": 1633464000, "adjclose": 3
      },
      {
        //2021-10-04 14:30:00.000
        "date": 1633354200, // Split
        "adjclose": 2
      },
      {
        // 2021-10-01 14:30:00.000
        "date": 1633095000, "adjclose": 1.5
      }
    ];

    JoinPricesTextAux.addTimestampForTesting(recentPricesList);
    JoinPricesTextAux.addTimestampForTesting(oldPricesList);

    List<dynamic> result =
        JoinPrices.joinPrices(oldPricesList, recentPricesList);

    JoinPricesTextAux.validateSizeAndContinuity(result, 4);

    // Validate the join after the split
    assert(result[0]['adjclose'] == 3);
    assert(result[1]['adjclose'] == 2);
    assert(result[2]['adjclose'] == 1.5);
    assert(result[3]['adjclose'] == 0.5);
  });
}
