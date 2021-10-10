import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/bigPicture/state/big_picture_state_provider.dart';
import 'package:turing_deal/bigPicture/ui/resume/strategy_resume_ui.dart';
import 'package:turing_deal/marketData/model/stock_picker.dart';

class BigPictureResumeList extends StatelessWidget {
  final Map<StockTicker, BuyAndHoldStrategyResult> data;

  const BigPictureResumeList(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BigPictureStateProvider bigPictureState =
    Provider.of<BigPictureStateProvider>(context, listen: false);

    List<StockTicker> tickers = data.keys.toList();

    double width = MediaQuery.of(context).size.width;
    int columns = (width / StrategyResume.RESUME_WIDTH).floor();
    columns = columns <= 0 ? 1 : columns;

    if(bigPictureState.isCompactView()){
      columns *= 3;
    }
    int lines = (tickers.length / columns).ceil();

    return ListView.builder(
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
    );
  }
}
