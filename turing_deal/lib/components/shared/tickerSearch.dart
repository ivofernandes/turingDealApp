import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:turing_deal/data/model/ticker.dart';
import 'package:turing_deal/data/static/TickersList.dart';

class TickerSearch extends SearchDelegate<Ticker>{

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
        onTap: () => close(context, Ticker(query, query)),
        child: Text(
            query,
            style: Theme.of(context).textTheme.headline6
        )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return Column(
      children: [

        suggestionTitle(Icon(Icons.view_headline), 'Main'),
        suggestion(TickersList.main),

        suggestionTitle(Icon(Icons.language), 'Countries'),
        suggestion(TickersList.countries),

        suggestionTitle(Icon(Icons.precision_manufacturing_outlined), 'Sectors'),
        suggestion(TickersList.sectors),

        // suggestionTitle(Icon(Icons.account_balance_outlined), 'Bonds'),
        //suggestion(TickersList.bonds),

        //suggestionTitle(Icon(Icons.workspaces_outline), 'Commodities'),
        //suggestion(TickersList.commodities)

      ],
    );

  }

  Widget suggestion(Map<String, String> tickers) {
    List<String> keys = tickers.keys.toList();

    List<String> filteredKeys = keys.where((element) {
      String lowerCaseQuery = query.toString().toLowerCase();

      return element.toString().toLowerCase().contains(lowerCaseQuery)
          || tickers[element].toString().toLowerCase().contains(lowerCaseQuery);
    }).toList();

    int size = filteredKeys.length;
    
    return Expanded(
      child: ListView.builder(
          itemCount: size,
          itemBuilder: (BuildContext context, int index){
            final String symbol = filteredKeys[index];
            return tickerWidget(context, symbol, tickers[symbol] );
          }),
    );
  }

  Widget tickerWidget(BuildContext context, String symbol, String description) {
    return GestureDetector(
      onTap: () => close(context, Ticker(symbol, description)),
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