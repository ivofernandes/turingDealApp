import 'package:flutter/material.dart';

class StrategyResumeItem extends StatelessWidget {
  final String title;
  final String value;
  final Function onTap;

  const StrategyResumeItem({required this.title, required this.value, required this.onTap, super.key});

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
            Text(value,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 10,
                    ),
                textAlign: TextAlign.right),
          ],
        ),
      );
}
