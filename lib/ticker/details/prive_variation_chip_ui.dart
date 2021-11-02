
import 'package:flutter/material.dart';
import 'package:turing_deal/big_picture/ui/resume/strategy_resume_ui.dart';
import 'package:turing_deal/shared/core/color_for_value.dart';

class PriceVariationChip extends StatelessWidget{
  String? prefix;
  double value;

  PriceVariationChip(this.prefix, this.value);

  @override
  Widget build(BuildContext context) {
    String text = value.toStringAsFixed(2) + '%';

    MediaQuery.of(context).size.width;

    return SizedBox(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.end,
        children: [
          prefix != null ? Text(
              prefix! + ': ' ,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 10
              ),
          ) : Container(),
          Center(
            child: Container(
              alignment: Alignment.bottomRight,
              width: 60,
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: ColorForValue().getColorForPriceVariation(value),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                  child: Text(text)),
            ),
          ),
        ],
      ),
    );
  }
}