import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:turing_deal/marketData/model/strategy.dart';
import 'package:turing_deal/marketData/model/ticker.dart';
import './strategyResumeHeader.dart';
import './details/tickerDetails.dart';
import '../state/BigPictureStateProvider.dart';
import 'strategyResumeDetails.dart';

class StrategyResume extends StatelessWidget {
  static final int RESUME_WIDTH = 350;

  final Ticker ticker;
  final StrategyResult strategy;
  final BigPictureStateProvider bigPictureState;

  StrategyResume(this.ticker, this.strategy, this.bigPictureState);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int columns = (width / RESUME_WIDTH).floor();
    double cardWidth = RESUME_WIDTH + (width % RESUME_WIDTH / columns);

    return Dismissible(
      key: GlobalKey(),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      onDismissed: (direction) {
        this.bigPictureState.removeTicker(this.ticker);
      },
      background: Container(
        color: Colors.red,
        child: Icon(Icons.close),
      ),
      child: Container(
        width: cardWidth,
        child: InkWell(
          onTap: () => Get.to(TickerDetails(ticker, this.bigPictureState)),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: strategy.progress > 0
                  ? Column(
                      children: [
                        StrategyResumeHeader(
                            this.ticker, this.strategy, this.bigPictureState),
                        StrategyResumeDetails(this.strategy),
                        strategy.progress < 100
                            ? CircularProgressIndicator()
                            : Container()
                      ],
                    )
                  : Column(
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
