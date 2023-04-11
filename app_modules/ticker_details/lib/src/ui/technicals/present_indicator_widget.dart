import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';

class PresentIndicatorWidget extends StatefulWidget {
  final String indicator;
  final double value;
  final double currentPrice;

  const PresentIndicatorWidget({
    required this.indicator,
    required this.value,
    required this.currentPrice,
    super.key,
  });

  @override
  State<PresentIndicatorWidget> createState() => _PresentIndicatorWidgetState();
}

class _PresentIndicatorWidgetState extends State<PresentIndicatorWidget> {
  @override
  Widget build(BuildContext context) {
    final bool isPositive = isValuePositive(widget.indicator, widget.value, widget.currentPrice);
    final Color color = isPositive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error;
    return GestureDetector(
      onTap: explainIndicator,
      child: Container(
        child: ListTile(
          title: Text(widget.indicator),
          trailing: Text(
            widget.value.toStringAsFixed(2),
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  bool isValuePositive(String indicator, double value, double currentPrice) {
    // Determine if the value should be considered positive or negative based on the indicator
    final String indicatorName = indicator.split('_').first;

    switch (indicatorName) {
      case 'RSI':
        return value <= 50;
      case '%R':
        return value <= -50;
      case 'EMA':
      case 'SMA':
      case 'VWMA':
        return currentPrice >= value;
      case 'BB':
        // Assuming value represents the difference between the current price and the middle band
        return value >= 0; // Positive if the current price is above the middle band
      case 'BOP':
        return value >= 0; // Positive if the balance of power is greater than or equal to 0
      case 'MFI':
        return value <= 20; // Oversold condition
      case 'P':
        // Assuming value represents the difference between the current price and a target price
        return value >= 0; // Positive if the current price is above the target price
      case 'STDDEV':
        // Assuming value represents the standard deviation of price changes
        return value <= 0.5; // Positive if the standard deviation is less than or equal to 0.5
      default:
        return true;
    }
  }

  void explainIndicator() {
    final String indicator = widget.indicator.split('_').first;

    switch (indicator) {
      case 'EMA':
        Web.launchLink(context, 'https://www.investopedia.com/terms/e/ema.asp');
        break;
      case 'SMA':
        Web.launchLink(context, 'https://www.investopedia.com/terms/s/sma.asp');
        break;
      case 'VWMA':
        Web.launchLink(context, 'https://www.investopedia.com/articles/trading/11/trading-with-vwap-mvwap.asp');
        break;
      case 'BB':
        Web.launchLink(context, 'https://www.investopedia.com/terms/b/bollingerbands.asp');
        break;
      case 'BOP':
        Web.launchLink(context, 'https://www.investopedia.com/terms/b/balanceofpower.asp');
        break;
      case 'MFI':
        Web.launchLink(context, 'https://www.investopedia.com/terms/m/mfi.asp');
        break;
      case 'P':
        Web.launchLink(context, 'https://www.investopedia.com/terms/p/price.asp');
        break;
      case 'STDDEV':
        Web.launchLink(context, 'https://www.investopedia.com/terms/s/standarddeviation.asp');
        break;
      case 'RSI':
        Web.launchLink(context, 'https://www.investopedia.com/terms/r/rsi.asp');
        break;
      case '%R':
        Web.launchLink(context, 'https://www.investopedia.com/terms/w/williamsr.asp');
        break;
      default:
        break;
    }
  }
}
