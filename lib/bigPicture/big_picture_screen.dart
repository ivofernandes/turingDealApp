import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/marketData/model/stock_picker.dart';
import 'package:turing_deal/shared/ui/checkError.dart';
import './ui/strategy_resume_ui.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import './state/big_picture_state_provider.dart';

class BigPictureScreen extends StatelessWidget{

  BigPictureScreen();

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context, listen: false);

    return Consumer<BigPictureStateProvider>(
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
              Map<StockTicker, BuyAndHoldStrategyResult> data = bigPictureState.getBigPictureData();
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
                        BuyAndHoldStrategyResult? strategy = data[ticker];
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
        });
  }


}