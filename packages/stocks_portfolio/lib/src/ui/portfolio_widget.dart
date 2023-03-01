import 'package:flutter/material.dart';
import 'package:stocks_portfolio/src/core/user_portfolio.dart';
import 'package:stocks_portfolio/src/ui/total_portfolio_amount.dart';

class PortfolioWidget extends StatefulWidget {
  final UserPortfolio portfolio;

  const PortfolioWidget({
    required this.portfolio,
    super.key,
  });

  @override
  _PortfolioWidgetState createState() => _PortfolioWidgetState();
}

class _PortfolioWidgetState extends State<PortfolioWidget> {
  @override
  Widget build(BuildContext context) {
    final allocations = widget.portfolio.portfolioAllocations;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            TotalPortfolioAmount(
              portfolio: widget.portfolio,
            ),
            Column(
              children: allocations.keys.map((ticker) {
                final tickerAllocation = allocations[ticker]!;
                return Column(
                  children: [
                    Row(
                      children: [
                        Text(ticker),
                        Switch(
                          value: tickerAllocation.isSelected,
                          onChanged: (value) {
                            setState(() {
                              tickerAllocation.isSelected = value;
                            });
                          },
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: tickerAllocation.numberOfShares.toString(),
                            onChanged: (value) {
                              changeTextInput(ticker, value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Slider(
                      value: tickerAllocation.percentageOfPortfolio,
                      onChanged: tickerAllocation.isSelected ? (value) => updateSliderPercentage(ticker, value) : null,
                      min: 0,
                      max: 100,
                    ),
                    Text('${tickerAllocation.percentageOfPortfolio.toStringAsFixed(2)}%'),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Updates the percentage of the portfolio for a given ticker.
  /// As the total percentage of the portfolio is 100%, the percentage of the
  /// other tickers has to be updated as well.
  void updateSliderPercentage(String ticker, double value) {
    final allocations = widget.portfolio.portfolioAllocations;
    allocations[ticker]!.percentageOfPortfolio = value;

    double totalPercentage = 0;
    for (var ticker in allocations.keys) {
      totalPercentage += allocations[ticker]!.percentageOfPortfolio;
    }

    for (var ticker in allocations.keys) {
      allocations[ticker]!.percentageOfPortfolio = allocations[ticker]!.percentageOfPortfolio / totalPercentage * 100;
    }

    updateNumberOfShares();

    setState(() {});
  }

  /// Updates the number of shares for each ticker.
  /// Taking in consideration the total amount of the portfolio and the
  /// percentage of each ticker.
  void updateNumberOfShares() {
    debugPrint('updateNumberOfShares');

    final allocations = widget.portfolio.portfolioAllocations;
    double totalAmount = 0;
    for (final ticker in allocations.keys) {
      totalAmount += allocations[ticker]!.numberOfShares * allocations[ticker]!.endPrice;
    }

    for (final ticker in allocations.keys) {
      final percentage = allocations[ticker]!.percentageOfPortfolio;
      var numberOfShares = 0;

      if (allocations[ticker]!.endPrice != 0) {
        numberOfShares = (percentage / 100 * totalAmount / allocations[ticker]!.endPrice).round();
      }
      debugPrint('$ticker | numberOfShares: $numberOfShares');

      allocations[ticker]!.numberOfShares = numberOfShares.round();
    }
  }

  void changeTextInput(String ticker, String value) {
    debugPrint('changeTextInput to $value');

    if (value == '') {
      value = '0';
    }

    final newValue = int.parse(value);
    widget.portfolio.portfolioAllocations[ticker]!.numberOfShares = newValue;
    if (newValue == 0) {
      widget.portfolio.portfolioAllocations[ticker]!.isSelected = false;
    } else {
      widget.portfolio.portfolioAllocations[ticker]!.isSelected = true;
    }

    updateAllocationsPercentages();
  }

  void updateAllocationsPercentages() {
    debugPrint('updateAllocationsPercentages');

    final allocations = widget.portfolio.portfolioAllocations;
    double totalAmount = 0;
    for (final ticker in allocations.keys) {
      totalAmount += allocations[ticker]!.numberOfShares * allocations[ticker]!.endPrice;
    }

    debugPrint('totalAmount: $totalAmount');
    widget.portfolio.amount = totalAmount;

    for (final ticker in allocations.keys) {
      final tickerAllocation = allocations[ticker]!;
      final tickerAmount = tickerAllocation.numberOfShares * tickerAllocation.endPrice;

      var percentage = 0.0;
      if (totalAmount != 0) {
        percentage = tickerAmount / totalAmount * 100;
      }
      tickerAllocation.percentageOfPortfolio = percentage;
      debugPrint('$ticker | percentageOfPortfolio: ${tickerAllocation.percentageOfPortfolio}');
    }

    setState(() {});
  }
}
