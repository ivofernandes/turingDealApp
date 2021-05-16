import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/components/bigPicture/strategyResume.dart';
import 'package:turing_deal/data/model/strategy.dart';
import 'package:turing_deal/data/model/ticker.dart';
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
              manageSearch(bigPictureState, context);

          return bigPictureScreen(context, bigPictureState);
        })
    );
  }

  Widget bigPictureScreen(BuildContext context, BigPictureStateProvider bigPictureState) {
    Map<Ticker,StrategyResult> data = bigPictureState.getBigPictureData();
    List<Ticker> tickers = data.keys.toList();

    double width = MediaQuery.of(context).size.width;
    int columns = (width / StrategyResume.RESUME_WIDTH).floor();
    int lines = (tickers.length / columns).ceil();

    return data.length == 0 ? Text('No strategies') :
        ListView.builder(
        itemCount: lines,
        itemBuilder: (BuildContext context, int index) {
          List<Widget> resumes = [];

          for(int i=index*columns ; i<(index+1) * columns && i<tickers.length ; i++) {
            Ticker ticker = tickers[i];
            StrategyResult strategy = data[ticker];
            resumes.add(StrategyResume(ticker, strategy, bigPictureState));
          }
          return Wrap(
            children: resumes,
          );
        }
        );
  }

  /// Manage the transition of a search from the app state to a big picture screen state
  void manageSearch(
      BigPictureStateProvider bigPictureState, BuildContext context) {
    List<Ticker> searchingTickers = this.appState.getSearching();

    if (searchingTickers != null && searchingTickers.isNotEmpty) {
      Ticker ticker = searchingTickers.removeAt(0);
      bigPictureState.addTicker(ticker, context);
    }
  }
}