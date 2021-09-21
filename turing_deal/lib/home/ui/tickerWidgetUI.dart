import 'package:flutter/material.dart';
import 'package:turing_deal/marketData/model/stockTicker.dart';

class TickerWidget extends StatelessWidget{
  final String symbol;
  final String description;
  final Function? onSelection;

  const TickerWidget({
    required this.symbol,
    this.description = '',
    this.onSelection
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(onSelection != null){
          onSelection!(StockTicker(symbol, description));
        }
      },
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
}