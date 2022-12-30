import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:turing_deal/home/ui/ticker_widget_ui.dart';

class TickersBlock extends StatelessWidget {
  final Icon icon;
  final String title;
  final Map<String, String> tickers;
  final String query;
  final Function close;

  const TickersBlock({
    required this.icon,
    required this.title,
    required this.tickers,
    required this.query,
    required this.close,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> keys = tickers.keys.toList();

    // Filter keys by text added
    final List<String> filteredKeys = keys.where((element) {
      final String lowerCaseQuery = query.toString().toLowerCase();

      final bool containsQuery = element
              .toLowerCase()
              .contains(lowerCaseQuery) ||
          tickers[element].toString().toLowerCase().contains(lowerCaseQuery);

      return containsQuery;
    }).toList();

    final int size = filteredKeys.length;

    return size > 0
        ? Column(
            children: [
              suggestionTitle(icon, title, filteredKeys, tickers, context),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: size,
                  itemBuilder: (BuildContext context, int index) {
                    final String symbol = filteredKeys[index];
                    return TickerWidget(
                      symbol: symbol,
                      description: tickers[symbol]!,
                      onSelection: (StockTicker ticker) {
                        close(context, <StockTicker>[ticker]);
                      },
                    );
                    // return tickerWidget(context, symbol, tickers[symbol]!);
                  }),
            ],
          )
        : const SizedBox();
  }

  /// Create a suggestion title that divide sectors from country etf etc
  /// @returns a widget ready
  Widget suggestionTitle(Icon icon, String s, List<String> filteredKeys,
          Map<String, String> tickers, BuildContext context) =>
      ListTile(
          leading: icon,
          title: Text(s),
          trailing: MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Theme.of(context).colorScheme.primary,
            child: const Text('Add all'),
            onPressed: () {
              final List<StockTicker> result = [];
              filteredKeys.forEach((element) {
                final String symbol = element.toString();
                result.add(StockTicker(
                  symbol: symbol,
                  description: tickers[symbol],
                ));
              });
              // Finish the search passing a result
              close(context, result);
            },
          ));
}
