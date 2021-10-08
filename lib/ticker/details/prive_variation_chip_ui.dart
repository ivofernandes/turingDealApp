
import 'package:flutter/material.dart';
import 'package:turing_deal/shared/core/color_for_value.dart';

class PriceVariationChip extends StatelessWidget{
  String? prefix;
  double value;

  PriceVariationChip(this.prefix, this.value);

  @override
  Widget build(BuildContext context) {
    String text = value.toStringAsFixed(2) + '%';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        prefix != null ? Text(prefix! + ': ' ) : Container(),
        Container(
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: ColorForValue().getColorForPriceVariation(value),
          ),
          child: Text(text),
        ),
      ],
    );
  }
}