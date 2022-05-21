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
  test('Join prices with old prices messed up', () async {
    // This dataset to join has multiple problems,
    // the date 2022-05-12 18:57:32.000 in the old prices has no match with the
    // last date in the recentPricesList that is 2022-05-12 05:00:00.000
    // and also has null in some element of the old list so to join the algorithm
    // will need to pick a nice date to use as reference
    List<Map<String, dynamic>> oldPricesList = [
      {
        'date': 1652726994,
        'open': 12409,
        'high': 12498.75,
        'low': 12190.25,
        'close': 12353.25,
        'volume': 527525,
        'adjclose': 12353.25
      },
      {
        'date': 1652414400,
        'open': 11891.5,
        'high': 12432,
        'low': 11891.5,
        'close': 12382.75,
        'volume': 878238,
        'adjclose': 12382.75
      },
      {
        'date': 1652378252,
        'open': 12004.5,
        'high': 12132.75,
        'low': 11693.25,
        'close': 11752.25,
        'volume': 679220,
        'adjclose': 11752.25
      },
      {
        'date': 1652309364,
        'open': 12004.5,
        'high': 12005.75,
        'low': 11950.25,
        'close': 11986.75,
        'volume': 5943,
        'adjclose': 11986.75
      },
      {
        'date': 1652155200,
        'open': 12206,
        'high': 12547,
        'low': 12102.25,
        'close': 12349,
        'volume': 816033,
        'adjclose': 12349
      },
      {
        'date': 1652068800,
        'open': 12605,
        'high': 12637.25,
        'low': 12135.25,
        'close': 12193.75,
        'volume': 816033,
        'adjclose': 12193.75
      },
      {
        'date': 1651968800,
        'open': null,
        'high': null,
        'low': null,
        'close': null,
        'volume': null,
        'adjclose': null
      }
    ];

    List<Map<String, dynamic>> recentPricesList = [
      {
        'date': 1653038296,
        'open': 11898,
        'high': 12096.75,
        'low': 11895,
        'close': 12094.25,
        'volume': 70366,
        'adjclose': 12094.25
      },
      {
        'date': 1652932800,
        'open': 11907,
        'high': 12076.75,
        'low': 11704,
        'close': 11878.25,
        'volume': 735386,
        'adjclose': 11878.25
      },
      {
        'date': 1652846400,
        'open': 12572,
        'high': 12594,
        'low': 11862.75,
        'close': 11935.5,
        'volume': 735386,
        'adjclose': 11935.5
      },
      {
        'date': 1652760000,
        'open': 12235.5,
        'high': 12578,
        'low': 12234,
        'close': 12560.25,
        'volume': 653222,
        'adjclose': 12560.25
      },
      {
        'date': 1652673600,
        'open': 12409,
        'high': 12498.75,
        'low': 12190.25,
        'close': 12244.75,
        'volume': 623715,
        'adjclose': 12244.75
      },
      {
        'date': 1652414400,
        'open': 11891.5,
        'high': 12432,
        'low': 11891.5,
        'close': 12382.75,
        'volume': 663517,
        'adjclose': 12382.75
      },
      {
        'date': 1652328000,
        'open': 12004.5,
        'high': 12132.75,
        'low': 11689,
        'close': 11947.25,
        'volume': 878238,
        'adjclose': 11947.25
      }
    ];

    addTimestampForTesting(recentPricesList);
    addTimestampForTesting(oldPricesList);

    List<dynamic> result =
        JoinPrices.joinPrices(oldPricesList, recentPricesList);

    JoinPricesTextAux.validateSizeAndContinuity(result, 11);
  });

  test('Join prices test without match', () async {
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
    ];

    JoinPricesTextAux.addTimestampForTesting(recentPricesList);
    JoinPricesTextAux.addTimestampForTesting(oldPricesList);

    List<dynamic> result =
        JoinPrices.joinPrices(oldPricesList, recentPricesList);

    JoinPricesTextAux.validateSizeAndContinuity(result, 4);

    // Validate the join after the split
    assert(result[0]['adjclose'] == 3);
    assert(result[1]['adjclose'] == 4);
    assert(result[2]['adjclose'] == 3);
    assert(result[3]['adjclose'] == 1);
  });
}

void addTimestampForTesting(List<Map<String, dynamic>> list) {
  for (int i = 0; i < list.length; i++) {
    list[i]['datetime'] =
        DateTime.fromMillisecondsSinceEpoch(list[i]['date'] * 1000);
  }
}
