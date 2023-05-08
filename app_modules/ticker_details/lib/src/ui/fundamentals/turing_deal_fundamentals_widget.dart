import 'package:flutter/material.dart';
import 'package:flutter_edgar_sec/flutter_edgar_sec.dart';

class TuringDealFundamentalsWidget extends StatelessWidget {
  final String symbol;

  const TuringDealFundamentalsWidget(
    this.symbol, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EdgarTableUI(
      symbol: symbol,
    );
  }
}
