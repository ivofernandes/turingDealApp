import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:turing_deal/home/ui/ticker_widget_ui.dart';
import 'package:turing_deal/home/ui/tickers_block.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';
import 'package:turing_deal/market_data/static/tickers_list.dart';

class TickerSearch extends SearchDelegate<List<StockTicker>> {
  TickerSearch({searchFieldLabel}) : super(searchFieldLabel: searchFieldLabel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, []);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return InkWell(
        onTap: () => close(
            context, [StockTicker(query.toUpperCase(), query.toUpperCase())]),
        child: TickerWidget(
          symbol: query.toUpperCase(),
          description: '',
          onSelection: (ticker) {
            close(context, [ticker]);
          },
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Widget searchingWidget = query != ''
        ? TickerWidget(
            symbol: query.toUpperCase(),
            onSelection: (ticker) => close(context, [ticker]))
        : Container();
    return SingleChildScrollView(
      child: Column(
        children: [
          searchingWidget,
          suggestion(Icon(Icons.view_headline), 'Main'.tr, TickersList.main),
          suggestion(Icon(Icons.precision_manufacturing_outlined), 'Sectors'.tr,
              TickersList.sectors),
          suggestion(Icon(Icons.workspaces_outline), 'Futures'.tr,
              TickersList.futures),
          suggestion(
              Icon(Icons.computer), 'Cryptos'.tr, TickersList.cryptoCurrencies),
          suggestion(
              Icon(Icons.language), 'Countries'.tr, TickersList.countries),
          suggestion(
              Icon(Icons.account_balance_outlined), 'Bonds', TickersList.bonds),
          suggestion(
              Icon(Icons.architecture_sharp), 'Sizes'.tr, TickersList.sizes),
          suggestion(
              Icon(Icons.business_sharp), 'Companies'.tr, TickersList.companies)
        ],
      ),
    );
  }

  TickersBlock suggestion(
      Icon icon, String title, Map<String, String> companies) {
    return TickersBlock(
      icon: icon,
      title: title,
      tickers: companies,
      query: query,
      close: close,
    );
  }
}
