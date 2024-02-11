import 'dart:ui';

import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';
import 'package:ticker_details/ticker_details.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/big_picture/ui/resume/strategy_resume_details_ui.dart';
import 'package:turing_deal/big_picture/ui/resume/strategy_resume_header_ui.dart';

/// StrategyResume is a StatelessWidget that displays the resume of a stock trading strategy.
/// It shows a card with details of the strategy's performance for a given stock ticker.
class StrategyResume extends StatelessWidget {
  // Constants for layout configuration
  static const double resumeWidth = 320;
  static const double resumeLeftColumn = 140 - 15;
  static const double resumeRightColumn = resumeWidth - resumeLeftColumn - 30;

  // Variables to hold ticker and strategy information
  final StockTicker ticker;
  final BuyAndHoldStrategyResult strategy;
  final double width;

  /// Constructor for StrategyResume
  const StrategyResume(
    this.ticker,
    this.strategy,
    this.width, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Accessing the state provider
    final BigPictureStateProvider bigPictureState = Provider.of<BigPictureStateProvider>(context, listen: false);

    // Calculating screen width and card width
    final double screenWidth = window.physicalSize.width / window.devicePixelRatio;
    final int columns = (screenWidth / resumeWidth).floor();
    double cardWidth = resumeWidth + (screenWidth % resumeWidth / columns);

    // Adjusting card width for compact view
    if (bigPictureState.isCompactView()) {
      cardWidth /= 3;
      cardWidth -= 5;
    }

    final double variation = (strategy.endPrice / strategy.previousClosePrice - 1) * 100;

    final Color color = ColorCalculation.getColorForValue(
      variation,
      PriceVariationChip.defaultPriceColors,
      ColorScaleTypeEnum.hsluv,
    );

    // Main widget structure
    return Dismissible(
      key: GlobalKey(),
      onDismissed: (direction) => bigPictureState.removeTicker(ticker),
      background: const ColoredBox(
        color: Colors.red,
        child: Icon(Icons.close),
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
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color,
                      blurRadius: 2,
                      offset: const Offset(2, 2), // Adjust the offset to control the shadow direction
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).cardColor,
                        blurRadius: 2,
                        offset: const Offset(2, 2), // Adjust the offset to control the shadow direction
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  child: strategy.progress > 0
                      ? Column(
                          children: [
                            StrategyResumeHeader(
                              ticker: ticker,
                              strategy: strategy,
                              cardWidth: cardWidth,
                              variation: variation,
                              color: color,
                            ),
                            StrategyResumeDetails(strategy),
                            strategy.progress < 100 ? const CircularProgressIndicator() : Container()
                          ],
                        )
                      : const Center(
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(),
                          ),
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
