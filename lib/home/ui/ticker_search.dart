import 'package:flutter/material.dart';
import 'package:interactive_i18n/interactive_i18n.dart';
import 'package:turing_deal/home/ui/ticker_widget_ui.dart';
import 'package:turing_deal/home/ui/tickers_block.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';
import 'package:turing_deal/market_data/static/tickers_list.dart';

class TickerSearch extends SearchDelegate<List<StockTicker>> {
  TickerSearch({super.searchFieldLabel});

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              query = '';
            })
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, []);
      });

  @override
  Widget buildResults(BuildContext context) => InkWell(
      onTap: () => close(
          context, [StockTicker(query.toUpperCase(), query.toUpperCase())]),
      child: TickerWidget(
        symbol: query.toUpperCase(),
        onSelection: (StockTicker ticker) {
          close(context, [ticker]);
        },
      ));

  @override
  Widget buildSuggestions(BuildContext context) {
    final Widget searchingWidget = query != ''
        ? TickerWidget(
            symbol: query.toUpperCase(),
            onSelection: (StockTicker ticker) => close(context, [ticker]))
        : Container();
    return SingleChildScrollView(
      child: Column(
        children: [
          searchingWidget,
          suggestion(const Icon(Icons.view_headline), 'Main'.t, TickersList.main),
          suggestion(const Icon(Icons.precision_manufacturing_outlined), 'Sectors'.t,
              TickersList.sectors),
          suggestion(
              const Icon(Icons.workspaces_outline), 'Futures'.t, TickersList.futures),
          suggestion(
              const Icon(Icons.computer), 'Cryptos'.t, TickersList.cryptoCurrencies),
          suggestion(
              const Icon(Icons.language), 'Countries'.t, TickersList.countries),
          suggestion(
              const Icon(Icons.account_balance_outlined), 'Bonds', TickersList.bonds),
          suggestion(
              const Icon(Icons.architecture_sharp), 'Sizes'.t, TickersList.sizes),
          suggestion(
              const Icon(Icons.business_sharp), 'Companies'.t, TickersList.companies)
        ],
      ),
    );
  }

  TickersBlock suggestion(
      Icon icon, String title, Map<String, String> companies) => TickersBlock(
      icon: icon,
      title: title,
      tickers: companies,
      query: query,
      close: close,
    );
}
