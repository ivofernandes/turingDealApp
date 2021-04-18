import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/components/loading.dart';
import 'package:turing_deal/data/model/strategy.dart';
import 'package:turing_deal/data/state/AppStateProvider.dart';
import 'package:turing_deal/data/state/BigPictureStateProvider.dart';

class BigPictureScreen extends StatelessWidget{
  AppStateProvider appState;

  BigPictureScreen(this.appState);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => BigPictureStateProvider(context),
        child: Consumer<BigPictureStateProvider>(
            builder: (context, bigPictureState, child) {
              return bigPictureScreen(context, bigPictureState);
            })
    );
  }

  Widget bigPictureScreen(BuildContext context, BigPictureStateProvider bigPictureState) {
    Map<String,Strategy> data = bigPictureState.getBigPictureData();
    List<String> tickers = data.keys.toList();

    return
        Column(
          children: [
            bigPictureState.isProcessingState() ?
            Loading(bigPictureState) :
            Expanded(
              child: ListView.builder(
              //controller: _scrollController,
              itemCount: tickers.length,
              itemBuilder: (BuildContext context, int index) {
                String ticker = tickers[index];
                Strategy strategy = data[ticker];

                ;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(ticker),
                        Text('Backtested from ' + DateFormat.yMd().format(strategy.startDate) + ' to ' + DateFormat.yMd().format(strategy.endDate)),
                        Text('CAGR: ' + strategy.CAGR.toStringAsFixed(2) + '%'),
                        Text('Dradown: ' + strategy.drawdown.toStringAsFixed(2) + '%'),
                        Text('MAR: ' + strategy.MAR.toStringAsFixed(2) )
                      ],
                    ),
                  ),
                );
              }
              ),
            ),
            ElevatedButton(
                onPressed: ()=> bigPictureState.loadData(),
                child: Text('reload'))
          ],
        );
  }

}