import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/data/model/ticker.dart';
import 'package:turing_deal/data/state/AppStateProvider.dart';
import 'package:turing_deal/data/state/BigPictureStateProvider.dart';
import 'package:turing_deal/data/static/TickersList.dart';

class TickerSearch extends SearchDelegate<List<Ticker>>{

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
          close(context, null);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return GestureDetector(
        onTap: () => close(context, [Ticker(query, query)]),
        child: Text(
            query,
            style: Theme.of(context).textTheme.headline6
        )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          tickerWidget(context, query, ''),

          suggestion(Icon(Icons.view_headline), 'Main', TickersList.main),

          suggestion(Icon(Icons.precision_manufacturing_outlined), 'Sectors', TickersList.sectors),

          suggestion(Icon(Icons.computer), 'Cryptos', TickersList.cryptoCurrencies),

          suggestion(Icon(Icons.language), 'Countries', TickersList.countries),

          suggestion(Icon(Icons.account_balance_outlined), 'Bonds', TickersList.bonds),

          suggestion(Icon(Icons.workspaces_outline), 'Commodities', TickersList.commodities),

          suggestion(Icon(Icons.architecture_sharp), 'Sizes',TickersList.sizes),

          suggestion(Icon(Icons.business_sharp), 'Companies', TickersList.companies)
        ],
      ),
    );

  }

  Widget suggestion(Icon icon, String title, Map<String, String> tickers) {
    List<String> keys = tickers.keys.toList();

    // Filter keys by text added
    List<String> filteredKeys = keys.where((element) {
      String lowerCaseQuery = query.toString().toLowerCase();

      bool containsQuery = element.toString().toLowerCase().contains(lowerCaseQuery)
          || tickers[element].toString().toLowerCase().contains(lowerCaseQuery);

      return containsQuery;
    }).toList();

    int size = filteredKeys.length;

    return size > 0 ? Column(
      children: [
        suggestionTitle(icon,title),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: size,
            itemBuilder: (BuildContext context, int index){
              final String symbol = filteredKeys[index];
              return tickerWidget(context, symbol, tickers[symbol]);
            }),
      ],
    ) : SizedBox();
  }

  Widget tickerWidget(BuildContext context, String symbol, String description) {
    return GestureDetector(
      onTap: () => close(context, [Ticker(symbol, description)]),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Card(
          child: Row(
            children: [
              ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 30.0,
                    minWidth: 80.0,
                  ),
                  child: Container(
                    color: Theme.of(context).backgroundColor.withOpacity(0.3),
                    child: Center(child:
                    Text(
                        symbol,
                        style: Theme.of(context).textTheme.headline6
                    )),
                  )),
              SizedBox(width:10),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }

  Widget suggestionTitle( icon, String s) {
    return ListTile(
      leading: icon,
      title: Text(s)
    );
  }
}