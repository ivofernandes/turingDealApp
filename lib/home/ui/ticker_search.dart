import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:turing_deal/home/ui/ticker_widget_ui.dart';
import 'package:turing_deal/home/ui/tickers_block.dart';
import 'package:turing_deal/marketData/model/stock_picker.dart';
import 'package:turing_deal/marketData/static/tickers_list.dart';

class TickerSearch extends SearchDelegate<List<StockTicker>>{

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: (){
            query = '';
          }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          close(context, []);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return InkWell(
        onTap: () => close(context, [StockTicker(query.toUpperCase(), query.toUpperCase())]),
        child: TickerWidget(
          symbol: query.toUpperCase(),
          description: '',
          onSelection: (ticker) {
            close(context, [ticker]);
          },
        )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Widget searchingWidget =
        query != '' ? TickerWidget(
            symbol: query.toUpperCase(),
            onSelection: (ticker) => close(context, [ticker])
        ) : Container();
    return SingleChildScrollView(
      child: Column(
        children: [
          searchingWidget,
          suggestion(
              Icon(Icons.view_headline), 'Main', TickersList.main),
          suggestion(Icon(Icons.precision_manufacturing_outlined), 'Sectors',
              TickersList.sectors),
          suggestion(Icon(Icons.computer), 'Cryptos',
              TickersList.cryptoCurrencies),
          suggestion(Icon(Icons.language), 'Countries', TickersList.countries),
          suggestion(Icon(Icons.account_balance_outlined), 'Bonds',
              TickersList.bonds),
          suggestion(Icon(Icons.workspaces_outline), 'Commodities', TickersList.commodities),

          suggestion(Icon(Icons.architecture_sharp), 'Sizes',TickersList.sizes),

          suggestion(Icon(Icons.business_sharp), 'Companies', TickersList.companies)
        ],
      ),
    );
  }

  TickersBlock suggestion(Icon icon, String title, Map<String, String> companies) {
    return TickersBlock(
      icon: icon,
      title: title,
      tickers: companies,
      query: query,
      close: close,
    );
  }
}