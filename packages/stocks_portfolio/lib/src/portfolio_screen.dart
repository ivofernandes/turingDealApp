import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:stocks_portfolio/src/core/portfolio_allocation.dart';
import 'package:stocks_portfolio/src/core/user_portfolio.dart';
import 'package:stocks_portfolio/src/ui/portfolio_widget.dart';

class PortfolioScreen extends StatelessWidget {
  final Map<StockTicker, BuyAndHoldStrategyResult> stocks;

  const PortfolioScreen({
    required this.stocks,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserPortfolio portfolio = getPortfolioData(stocks);
    return PortfolioWidget(
      portfolio: portfolio,
    );
  }

  UserPortfolio getPortfolioData(Map<StockTicker, BuyAndHoldStrategyResult> bigPictureData) {
    final Map<String, PortfolioAllocation> portfolioAllocations = {};

    for (final ticker in bigPictureData.keys.toList()) {
      final endPrice = bigPictureData[ticker]!.endPrice;
      portfolioAllocations[ticker.symbol] = PortfolioAllocation(endPrice: endPrice);
    }

    return UserPortfolio(
      portfolioAllocations: portfolioAllocations,
    );
  }
}
