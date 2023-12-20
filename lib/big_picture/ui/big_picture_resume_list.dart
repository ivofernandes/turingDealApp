import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:td_ui/src/ui/apps_banner.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/big_picture/ui/resume/strategy_resume_ui.dart';
import 'package:turing_deal/shared/environment.dart';

class BigPictureResumeList extends StatelessWidget {
  final Map<StockTicker, BuyAndHoldStrategyResult> data;

  const BigPictureResumeList(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final BigPictureStateProvider bigPictureState = Provider.of<BigPictureStateProvider>(context, listen: false);
    final List<StockTicker> tickers = data.keys.toList();
    final double width = MediaQuery.of(context).size.width;
    final int columns = _calculateColumns(width, bigPictureState.isCompactView());
    final int lines = (tickers.length / columns).ceil();

    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          bigPictureState.isMockedData()
              ? const AppsBanner(
                  playStoreUrl: Environment.playStoreUrl,
                  appStoreUrl: Environment.appStoreUrl,
                )
              : Container(),
          Expanded(
            child: ListView.builder(
                controller: bigPictureState.scrollController,
                itemCount: lines,
                itemBuilder: (BuildContext context, int index) {
                  final List<Widget> resumes = [];

                  for (int i = index * columns; i < (index + 1) * columns && i < tickers.length; i++) {
                    final StockTicker ticker = tickers[i];
                    final BuyAndHoldStrategyResult? strategy = data[ticker];
                    resumes.add(StrategyResume(
                      ticker,
                      strategy!,
                      width / columns,
                    ));
                  }
                  return Wrap(
                    children: resumes,
                  );
                }),
          ),
        ],
      ),
    );
  }

  int _calculateColumns(double width, bool isCompactView) {
    int columns = (width / StrategyResume.resumeWidth).floor();
    columns = columns <= 0 ? 1 : columns;
    if (isCompactView) {
      columns *= 3;
    }
    return columns;
  }
}
