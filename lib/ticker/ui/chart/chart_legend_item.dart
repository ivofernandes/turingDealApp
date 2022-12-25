import 'package:flutter/material.dart';

class ChartLegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const ChartLegendItem(this.color, this.text);

  @override
  Widget build(BuildContext context) => Row(
      children: [
        Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(text)
      ],
    );
}
