import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';

class TickerTitle extends StatelessWidget {
  final StockTicker ticker;
  final double width;
  final TextAlign textAlign;

  const TickerTitle({
    required this.ticker,
    required this.width,
    required this.textAlign,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          width: width,
          child: Text(
            ticker.symbol,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: textAlign,
          ),
        ),
      );
}
