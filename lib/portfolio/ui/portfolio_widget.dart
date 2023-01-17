import 'package:flutter/material.dart';
import 'package:turing_deal/portfolio/core/user_portfolio.dart';
import 'package:turing_deal/portfolio/ui/total_portfolio_amount.dart';

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
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              TotalPortfolioAmount(
                portfolio: widget.portfolio,
              ),
              Column(
                children: [
                  for (var ticker in widget.portfolio.portfolioAllocations.keys)
                    Row(
                      children: [
                        Text(ticker),
                        Switch(
                          value: widget.portfolio.portfolioAllocations[ticker]!
                              .isSelected,
                          onChanged: (value) {
                            setState(() {
                              widget.portfolio.portfolioAllocations[ticker]!
                                  .isSelected = value;
                            });
                          },
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue: widget.portfolio
                                .portfolioAllocations[ticker]!.numberOfShares
                                .toString(),
                            onChanged: (value) {
                              if (value == '') {
                                return;
                              }

                              final newValue = double.parse(value);
                              widget.portfolio.portfolioAllocations[ticker]!
                                  .numberOfShares = newValue;
                              if (newValue == 0) {
                                setState(() {
                                  widget.portfolio.portfolioAllocations[ticker]!
                                      .isSelected = false;
                                });
                              } else {
                                setState(() {
                                  widget.portfolio.portfolioAllocations[ticker]!
                                      .isSelected = true;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      );
}
