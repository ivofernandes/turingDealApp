import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';

class PriceVariationChip extends StatelessWidget {
  final String? prefix;
  final double value;

  const PriceVariationChip(
    this.prefix,
    this.value, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String text = '${value.toStringAsFixed(2)}%';

    return SizedBox(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.end,
        children: [
          prefix != null
              ? Text(
                  '${prefix!}: ',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 10),
                )
              : Container(),
          Center(
            child: Container(
              margin: const EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: ColorScaleWidget(
                  value: value,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      alignment: Alignment.bottomRight,
                      width: 60,
                      child: FittedBox(fit: BoxFit.scaleDown, child: Text(text))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
