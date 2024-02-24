import 'package:app_dependencies/app_dependencies.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';

mixin BigPictureNormalizePeriodState {
  bool _normalizing = false;
  bool _normalized = false;

  bool isNormalizing() => _normalizing;

  bool isNormalized() => _normalized;

  void resetNormalize() {
    _normalizing = false;
    _normalized = false;
  }

  Future<void> normalizePeriod(BigPictureStateProvider bigPictureState) async {
    _normalizing = true;
    bigPictureState.refresh();

    final Map<StockTicker, BuyAndHoldStrategyResult> bigPictureData = bigPictureState.getBigPictureData();
    final List<BuyAndHoldStrategyResult> results = bigPictureData.values.toList();

    // Pick the smallest strategy, with start day closest to current date
    DateTime start = results.first.startDate ?? DateTime.fromMillisecondsSinceEpoch(0);
    for (final BuyAndHoldStrategyResult result in results) {
      if (result.startDate?.isAfter(start) ?? false) {
        start = result.startDate!;
      }
    }

    // Redo all searches
    final List<StockTicker> tickers = bigPictureData.keys.toList();
    for (final StockTicker ticker in tickers) {
      await bigPictureState.addTicker(ticker, startDate: start);
    }

    _normalizing = false;
    _normalized = true;
    bigPictureState.refresh();
  }
}
