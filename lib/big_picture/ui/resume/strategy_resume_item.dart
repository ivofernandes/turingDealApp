import 'package:flutter/material.dart';
import 'package:turing_deal/shared/ui/UIUtils.dart';

class StrategyResumeItem extends StatelessWidget{
  final String title;
  final String value;
  final Function onTap;

  const StrategyResumeItem({
    required this.title,
    required this.value,
    required this.onTap,
    Key? key
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    return  InkWell(
        onTap: () => onTap.call(),
        child: Row(
          children: [
            Text(
                title,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 12,
                ),
                textAlign: TextAlign.left
            ),
            Spacer(),
            Text(
                value,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 12,
                ),
                textAlign: TextAlign.right
            ),
          ],
        )
    );
  }
}