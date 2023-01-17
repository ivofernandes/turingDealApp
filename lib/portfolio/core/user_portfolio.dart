import 'package:turing_deal/portfolio/core/portfolio_allocation.dart';

class UserPortfolio {
  Map<String, PortfolioAllocation> portfolioAllocations;

  UserPortfolio({
    required this.portfolioAllocations,
  });

  @override
  String toString() => portfolioAllocations.toString();
}
