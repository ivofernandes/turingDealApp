import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';

class TickerWidget extends StatelessWidget {
  final String symbol;
  final String description;
  final Function? onSelection;

  const TickerWidget(
      {required this.symbol, this.description = '', this.onSelection});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          if (onSelection != null) {
            onSelection!(StockTicker(
              symbol: symbol,
              description: description,
            ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Card(
            child: Row(
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 30,
                      minWidth: 80,
                      maxHeight: 30,
                    ),
                    child: Container(
                      color: Theme.of(context).backgroundColor.withOpacity(0.3),
                      child: Center(
                          child: Text(symbol.toUpperCase(),
                              style: Theme.of(context).textTheme.headline6)),
                    )),
                const SizedBox(width: 10),
                Text(description),
              ],
            ),
          ),
        ),
      );
}
