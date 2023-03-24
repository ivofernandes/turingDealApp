import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ticker_details/src/ui/technicals/add_indicator_widget.dart';

class TuringDealTechnicalsWidget extends StatefulWidget {
  final List<YahooFinanceCandleData> prices;

  const TuringDealTechnicalsWidget(
    this.prices, {
    super.key,
  });

  @override
  State<TuringDealTechnicalsWidget> createState() => _TuringDealTechnicalsWidgetState();
}

class _TuringDealTechnicalsWidgetState extends State<TuringDealTechnicalsWidget> {
  static List<String> indicatorsList = ['SMA', 'EMA', 'RSI', 'BB', 'BOP', 'MFI', 'P', 'STDDEV', 'VWMA', '%R'];

  List<String> indicators = ['RSI_200', 'RSI_50', 'RSI_20'];

  void _addIndicator(String indicator, int period) {
    setState(() {
      indicators.add('${indicator}_$period');
    });
  }

  void _removeIndicator(String indicator) {
    setState(() {
      indicators.remove(indicator);
    });
  }

  @override
  Widget build(BuildContext context) {
    CalculateIndicators.calculateIndicators(widget.prices, indicators);
    Map<String, double> prices = widget.prices.last.indicators;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // Widget to show the values of the indicators
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: indicators.map((indicator) {
                  if (!prices.containsKey(indicator)) {
                    return Container();
                  }

                  return Dismissible(
                    key: Key(indicator),
                    onDismissed: (direction) {
                      _removeIndicator(indicator);
                    },
                    child: ListTile(
                      title: Text(indicator),
                      trailing: Text(prices[indicator]!.toStringAsFixed(2)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // AddIndicatorWidget
          AddIndicatorWidget(
            indicatorsList: indicatorsList,
            onAddIndicator: (indicator, period) {
              _addIndicator(indicator, period);
            },
          ),
        ],
      ),
    );
  }
}
