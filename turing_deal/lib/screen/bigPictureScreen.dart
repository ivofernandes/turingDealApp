import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/data/state/AppStateProvider.dart';

class BigPictureScreen extends StatelessWidget{
  AppStateProvider appState;

  BigPictureScreen(this.appState);

  @override
  Widget build(BuildContext context) {
    Widget bigPicture = renderBigPicture(this.appState.getBigPictureData());
    return SingleChildScrollView(
        child: Column(
          children: [
            this.appState.getBigPictureData().isNotEmpty ?
            bigPicture : CircularProgressIndicator()
          ],
        )
    );
  }

  Widget renderBigPicture(Map<String, dynamic> bigPictureData) {
    //TODO use dataframe to parse and show metrics
    return Text(this.appState.getBigPictureData().toString());
  }

}