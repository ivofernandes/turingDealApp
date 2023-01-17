import 'package:flutter/material.dart';
import 'package:turing_deal/portfolio/core/user_portfolio.dart';

class TotalPortfolioAmount extends StatelessWidget {
  final UserPortfolio portfolio;

  const TotalPortfolioAmount({
    required this.portfolio,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    portfolio.portfolioAllocations.forEach((key, value) {
      totalAmount += value.numberOfShares * value.endPrice;
    });
    return Text('Total Portfolio Amount: ${totalAmount.toStringAsFixed(2)}');
  }
}
