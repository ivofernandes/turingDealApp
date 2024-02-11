import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:td_ui/src/my_app_context.dart';

class PriceVariationChip extends StatelessWidget {
  static final Map<double, Color> defaultPriceColors = {
    -1.5: Theme.of(MyAppContext.context).colorScheme.error,
    0.0: Colors.grey,
    1.5: Theme.of(MyAppContext.context).colorScheme.primary
  };

  final String prefix;
  final double value;

  final Map<double, Color>? stops;

  const PriceVariationChip({
    this.prefix = '',
    this.value = 0,
    this.stops,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String text = '${value.toStringAsFixed(2)}%';

    final Map<double, Color> colorStops = stops ?? defaultPriceColors;

    return SizedBox(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.end,
        children: [
          prefix != ''
              ? Text(
                  '$prefix: ',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 10),
                )
              : Container(),
          Center(
            child: Container(
              margin: const EdgeInsets.all(2),
              child: ColorScaleStopsWidget(
                value: value,
                colorStops: colorStops,
                borderRadius: BorderRadius.circular(20),
                padding: const EdgeInsets.all(2),
                child: Container(
                  alignment: Alignment.bottomRight,
                  width: 60,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(text),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
