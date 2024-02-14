import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';

class StrategyResumeItem extends StatelessWidget {
  final String title;
  final String text;
  final Function onTap;

  final double value;

  final Map<double, Color> stops;

  const StrategyResumeItem({
    required this.title,
    required this.text,
    required this.onTap,
    required this.value,
    required this.stops,
    super.key,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => onTap.call(),
        child: Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 10,
                    decoration: TextDecoration.underline,
                  ),
              textAlign: TextAlign.left,
            ),
            Text(
              ': ',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 10,
                  ),
              textAlign: TextAlign.left,
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.all(2),
              child: ColorScaleStopsWidget(
                borderRadius: BorderRadius.circular(20),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                value: value,
                colorStops: stops,
                child: Text(text,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 10,
                        ),
                    textAlign: TextAlign.right),
              ),
            ),
          ],
        ),
      );
}
