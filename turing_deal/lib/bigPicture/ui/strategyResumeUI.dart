import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buyAndHoldStrategyResult.dart';
import 'package:turing_deal/marketData/model/stockTicker.dart';
import './strategyResumeHeaderUI.dart';
import '../../ticker/tickerScreen.dart';
import '../state/BigPictureStateProvider.dart';
import 'strategyResumeDetailsUI.dart';

class StrategyResume extends StatelessWidget {
  static final int RESUME_WIDTH = 350;

  final StockTicker ticker;
  final BuyAndHoldStrategyResult strategy;

  StrategyResume(this.ticker, this.strategy);

  @override
  Widget build(BuildContext context) {
    BigPictureStateProvider bigPictureState =
      Provider.of<BigPictureStateProvider>(context, listen: false);

    double width = window.physicalSize.width / window.devicePixelRatio;
    int columns = (width / RESUME_WIDTH).floor();
    double cardWidth = RESUME_WIDTH + (width % RESUME_WIDTH / columns);

    if(bigPictureState.isCompactView()){
      cardWidth /= 3;
    }

    return Dismissible(
      key: GlobalKey(),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      onDismissed: (direction) => bigPictureState.removeTicker(this.ticker),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.close),
      ),
      child: Container(
        width: cardWidth,
        child: InkWell(
          onTap: () => Get.to(TickerScreen(ticker)),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: strategy.progress > 0
                  ? Column(
                      children: [
                        StrategyResumeHeader(
                            this.ticker, this.strategy),
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
