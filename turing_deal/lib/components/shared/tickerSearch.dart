import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:turing_deal/data/model/ticker.dart';
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
          close(context, []);
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
    Widget searchingWidget =
        query != '' ? tickerWidget(context, query, '') : Container();
    return SingleChildScrollView(
      child: Column(
        children: [
          searchingWidget,
          suggestion(
              Icon(Icons.view_headline), 'Main', TickersList.main, context),
          suggestion(Icon(Icons.precision_manufacturing_outlined), 'Sectors',
              TickersList.sectors, context),
          suggestion(Icon(Icons.computer), 'Cryptos',
              TickersList.cryptoCurrencies, context),
          suggestion(Icon(Icons.language), 'Countries', TickersList.countries,
              context),
          suggestion(Icon(Icons.account_balance_outlined), 'Bonds',
              TickersList.bonds, context),
          suggestion(Icon(Icons.workspaces_outline), 'Commodities', TickersList.commodities, context),

          suggestion(Icon(Icons.architecture_sharp), 'Sizes',TickersList.sizes, context),

          suggestion(Icon(Icons.business_sharp), 'Companies', TickersList.companies, context)
        ],
      ),
    );
  }

  Widget suggestion(Icon icon, String title, Map<String, String> tickers, BuildContext context) {
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
        suggestionTitle(icon,title, filteredKeys, tickers, context),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: size,
            itemBuilder: (BuildContext context, int index){
              final String symbol = filteredKeys[index];
              return tickerWidget(context, symbol, tickers[symbol]!);
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
                        symbol.toUpperCase(),
                            style: Theme.of(context).textTheme.headline6)),
                  )),
              SizedBox(width:10),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }

  /// Create a suggestion title that divide sectors from country etf etc
  /// @returns a widget ready
  Widget suggestionTitle(Icon icon, String s, List<String> filteredKeys,
      Map<String, String> tickers, BuildContext context) {

    return ListTile(
      leading: icon,
      title: Text(s),
      trailing: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0) ),
        color: Theme.of(context).accentColor,
        child: Text('Add all'),
        onPressed: () {
          List<Ticker> result = [];
          filteredKeys.forEach((element) {
            String symbol = element.toString();
            result.add(Ticker(symbol, tickers[symbol]));
          });
          // Finish the search passing a result
          close(context, result);
        },
      )
    );
  }
}