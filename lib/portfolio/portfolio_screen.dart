import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/portfolio/ui/portfolio_widget.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final BigPictureStateProvider bigPictureState =
        Provider.of<BigPictureStateProvider>(context, listen: false);
    final Map<String, double> pricesOfSymbols =
        getListFromSymbolToPrice(bigPictureState.getBigPictureData());

    return PortfolioWidget(
      pricesOfSymbols: pricesOfSymbols,
    );
  }

  Map<String, double> getListFromSymbolToPrice(
      Map<StockTicker, BuyAndHoldStrategyResult> bigPictureData) {
    final Map<String, double> pricesOfSymbols = {};

    final List<StockTicker> tickers = bigPictureData.keys.toList();
    for (final ticker in tickers) {
      pricesOfSymbols[ticker.symbol] = bigPictureData[ticker]!.endPrice;
    }

    return pricesOfSymbols;
  }
}
