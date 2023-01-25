import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/portfolio/core/portfolio_allocation.dart';
import 'package:turing_deal/portfolio/core/user_portfolio.dart';
import 'package:turing_deal/portfolio/ui/portfolio_widget.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final BigPictureStateProvider bigPictureState =
        Provider.of<BigPictureStateProvider>(context, listen: false);

    final UserPortfolio portfolio = getPortfolioData(
      bigPictureState.getBigPictureData(),
    );
    return PortfolioWidget(
      portfolio: portfolio,
    );
  }

  UserPortfolio getPortfolioData(
      Map<StockTicker, BuyAndHoldStrategyResult> bigPictureData) {
    final Map<String, PortfolioAllocation> portfolioAllocations = {};

    for (final ticker in bigPictureData.keys.toList()) {
      final endPrice = bigPictureData[ticker]!.endPrice;
      portfolioAllocations[ticker.symbol] =
          PortfolioAllocation(endPrice: endPrice);
    }

    return UserPortfolio(
      portfolioAllocations: portfolioAllocations,
    );
  }
}
