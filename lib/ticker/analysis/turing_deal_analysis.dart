import 'package:flutter/cupertino.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';
import 'package:turing_deal/ticker/analysis/variation/variation_proportion.dart';

class TuringDealAnalysis extends StatelessWidget {
  final List<CandlePrice> data;
  const TuringDealAnalysis(this.data);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VariationProportion(
            data: data,
            delta: 1,
          ),
          VariationProportion(data: data, delta: 5),
          VariationProportion(data: data, delta: 20)
        ],
      ),
    );
  }
}
