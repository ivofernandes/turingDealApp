import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/data/state/BigPictureStateProvider.dart';

class Loading extends StatelessWidget{

  BigPictureStateProvider bigPictureState;

  Loading(this.bigPictureState);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('State: '),
            Text(this.bigPictureState.getLoadingState().toString())
          ],
        ),
        LinearProgressIndicator(),
        ElevatedButton(
            onPressed: ()=> this.bigPictureState.loadData(),
            child: Text('reload'))
      ],
    );
  }

}