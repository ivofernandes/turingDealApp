import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/big_picture/ui/resume/strategy_resume_details_ui.dart';
import 'package:turing_deal/big_picture/ui/resume/strategy_resume_header_ui.dart';
import 'package:turing_deal/ticker/ticker_screen.dart';

class StrategyResume extends StatelessWidget {
  static const double RESUME_WIDTH = 320;
  static const double RESUME_LEFT_COLUMN = 140 - 15;
  static const double RESUME_RIGHT_COLUMN =
      RESUME_WIDTH - RESUME_LEFT_COLUMN - 30;

  final StockTicker ticker;
  final BuyAndHoldStrategyResult strategy;
  final double width;

  const StrategyResume(this.ticker, this.strategy, this.width);

  @override
  Widget build(BuildContext context) {
    final BigPictureStateProvider bigPictureState =
        Provider.of<BigPictureStateProvider>(context, listen: false);

    final double screenWidth =
        window.physicalSize.width / window.devicePixelRatio;
    final int columns = (screenWidth / RESUME_WIDTH).floor();
    double cardWidth = RESUME_WIDTH + (screenWidth % RESUME_WIDTH / columns);

    if (bigPictureState.isCompactView()) {
      cardWidth /= 3;
      cardWidth -= 5;
      print('card width: $cardWidth');
    }

    return Dismissible(
      key: GlobalKey(),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      onDismissed: (direction) => bigPictureState.removeTicker(ticker),
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.close),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 190),
        child: SizedBox(
          width: cardWidth,
          child: InkWell(
            onTap: () {
              if (!bigPictureState.isMockedData()) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TickerScreen(ticker),
                  ),
                );
              }
            },
            child: PinchZoomReleaseUnzoomWidget(
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: strategy.progress > 0
                      ? Column(
                          children: [
                            StrategyResumeHeader(ticker, strategy, cardWidth),
                            StrategyResumeDetails(strategy),
                            strategy.progress < 100
                                ? const CircularProgressIndicator()
                                : Container()
                          ],
                        )
                      : Column(
                          children: const [
                            CircularProgressIndicator(),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
