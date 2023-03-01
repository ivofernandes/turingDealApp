import 'package:flutter/material.dart';
import 'package:stocks_portfolio/src/core/user_portfolio.dart';

/// Widget to control the amount of money in the portfolio
/// by presenting a text field to the user.
/// When the text field is changed, the value is updated in the user portfolio.
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

    const oldText = Text('Total Portfolio Amount');

    /// Text field to change the total amount of money in the portfolio.
    return Row(
      children: [
        oldText,
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: TextEditingController(text: totalAmount.toStringAsFixed(2)),
            onChanged: (value) {
              if (value == '') {
                return;
              }

              final newValue = double.parse(value);
              portfolio.amount = newValue;
            },
          ),
        ),
      ],
    );
  }
}
