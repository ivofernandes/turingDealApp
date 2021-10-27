import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/marketData/model/stock_picker.dart';
import 'strategy_resume_header_ui.dart';
import '../../../ticker/ticker_screen.dart';
import '../../state/big_picture_state_provider.dart';
import 'strategy_resume_details_ui.dart';

class StrategyResume extends StatelessWidget {
  static const double RESUME_WIDTH = 320;
  static const double RESUME_LEFT_COLUMN = 140 - 15;
  static const double RESUME_RIGHT_COLUMN = RESUME_WIDTH - RESUME_LEFT_COLUMN- 30;


  final StockTicker ticker;
  final BuyAndHoldStrategyResult strategy;
  final double width;

  StrategyResume(this.ticker, this.strategy, this.width);

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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 190
        ),
        child: Container(
          width: cardWidth,
          child: InkWell(
            onTap: () => Get.to(TickerScreen(ticker)),
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: strategy.progress > 0
                    ? Column(
                        children: [
                          StrategyResumeHeader(
                              this.ticker, this.strategy, width),
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
      ),
    );
  }
}
