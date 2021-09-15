import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/marketData/model/strategy.dart';
import 'package:turing_deal/marketData/model/stockTicker.dart';
import 'package:turing_deal/shared/components/checkError.dart';
import './components/strategyResume.dart';
import 'package:turing_deal/home/state/AppStateProvider.dart';
import './state/BigPictureStateProvider.dart';

class BigPictureScreen extends StatelessWidget{

  BigPictureScreen();

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context, listen: false);

    return ChangeNotifierProvider(
        create: (_) => BigPictureStateProvider(context),
        child: Consumer<BigPictureStateProvider>(
            builder: (context, bigPictureState, child) {
              // Manage the transition of a search from the app state to a big picture screen state
              List<StockTicker>? searchingTickers = appState.getSearching();

              if (searchingTickers != null && searchingTickers.isNotEmpty) {
                StockTicker ticker = searchingTickers.removeAt(0);
                bigPictureState.addTicker(ticker, context).onError(
                        (error, stackTrace) {
                      CheckError.checkErrorState('Can\'t and the ticker ' + ticker.symbol, context);
                    });
              }

              // Return the big picture screen
              Map<StockTicker, StrategyResult> data = bigPictureState.getBigPictureData();
              List<StockTicker> tickers = data.keys.toList();

              double width = MediaQuery.of(context).size.width;
              int columns = (width / StrategyResume.RESUME_WIDTH).floor();
              columns = columns <= 0 ? 1 : columns;

              if(bigPictureState.isCompactView()){
                columns *= 3;
              }
              int lines = (tickers.length / columns).ceil();

              return data.length == 0
                  ? Text('No strategies')
                  : Scaffold(
                    body: ListView.builder(
                    itemCount: lines,
                    itemBuilder: (BuildContext context, int index) {
                      List<Widget> resumes = [];

                      for (int i = index * columns;
                      i < (index + 1) * columns && i < tickers.length;
                      i++) {
                        StockTicker ticker = tickers[i];
                        StrategyResult? strategy = data[ticker];
                        resumes.add(StrategyResume(ticker, strategy!));
                      }
                      return Wrap(
                        children: resumes,
                      );
                    }
              ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => bigPictureState.toogleCompactView(),
                  child: Icon(
                      bigPictureState.isCompactView() ? Icons.view_agenda_rounded : Icons.view_comfortable_sharp
                  )
                ),
            );
        })
    );
  }


}