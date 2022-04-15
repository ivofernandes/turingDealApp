import 'package:flutter/material.dart';
import 'package:turing_deal/home/ui/ticker_widget_ui.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';

class TickersBlock extends StatelessWidget {
  final Icon icon;
  final String title;
  final Map<String, String> tickers;
  final String query;
  final Function close;

  const TickersBlock(
      {required this.icon,
      required this.title,
      required this.tickers,
      required this.query,
      required this.close,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> keys = tickers.keys.toList();

    // Filter keys by text added
    List<String> filteredKeys = keys.where((element) {
      String lowerCaseQuery = query.toString().toLowerCase();

      bool containsQuery = element
              .toString()
              .toLowerCase()
              .contains(lowerCaseQuery) ||
          tickers[element].toString().toLowerCase().contains(lowerCaseQuery);

      return containsQuery;
    }).toList();

    int size = filteredKeys.length;

    return size > 0
        ? Column(
            children: [
              suggestionTitle(icon, title, filteredKeys, tickers, context),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: size,
                  itemBuilder: (BuildContext context, int index) {
                    final String symbol = filteredKeys[index];
                    return TickerWidget(
                      symbol: symbol,
                      description: tickers[symbol]!,
                      onSelection: (ticker) {
                        close(context, <StockTicker>[ticker]);
                      },
                    );
                    // return tickerWidget(context, symbol, tickers[symbol]!);
                  }),
            ],
          )
        : SizedBox();
  }

  /// Create a suggestion title that divide sectors from country etf etc
  /// @returns a widget ready
  Widget suggestionTitle(Icon icon, String s, List<String> filteredKeys,
      Map<String, String> tickers, BuildContext context) {
    return ListTile(
        leading: icon,
        title: Text(s),
        trailing: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Theme.of(context).colorScheme.primary,
          child: Text('Add all'),
          onPressed: () {
            List<StockTicker> result = [];
            filteredKeys.forEach((element) {
              String symbol = element.toString();
              result.add(StockTicker(symbol, tickers[symbol]));
            });
            // Finish the search passing a result
            close(context, result);
          },
        ));
  }
}
